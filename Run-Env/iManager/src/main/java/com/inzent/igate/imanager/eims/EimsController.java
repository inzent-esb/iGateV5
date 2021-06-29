package com.inzent.igate.imanager.eims ;

import java.io.InputStreamReader ;
import java.nio.charset.StandardCharsets ;
import java.util.HashMap ;
import java.util.LinkedList ;
import java.util.List ;
import java.util.Map ;
import java.util.concurrent.ExecutorService ;
import java.util.concurrent.Executors ;

import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.apache.commons.lang3.StringUtils ;
import org.apache.commons.logging.Log ;
import org.apache.commons.logging.LogFactory ;
import org.springframework.beans.factory.annotation.Autowired ;
import org.springframework.beans.factory.annotation.Qualifier ;
import org.springframework.stereotype.Controller ;
import org.springframework.transaction.TransactionStatus ;
import org.springframework.transaction.support.TransactionCallback ;
import org.springframework.transaction.support.TransactionTemplate ;
import org.springframework.ui.ExtendedModelMap ;
import org.springframework.validation.MapBindingResult ;
import org.springframework.web.bind.annotation.RequestMapping ;
import org.springframework.web.bind.annotation.RequestMethod ;
import org.springframework.web.bind.annotation.RequestParam ;

import com.fasterxml.jackson.databind.JsonNode ;
import com.fasterxml.jackson.databind.node.ArrayNode ;
import com.fasterxml.jackson.databind.node.ObjectNode ;
import com.inzent.igate.imanager.interfaces.InterfaceService ;
import com.inzent.igate.imanager.record.RecordService ;
import com.inzent.igate.imanager.service.ServiceService ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.imanager.controller.HttpSession ;
import com.inzent.imanager.marshaller.JsonMarshaller ;

/**
 * <code>EimsController</code> eims 전문 받아 update, insert, delete 수행하는 controller
 *
 * @since 2021. 2. 7.
 * @version 5.0
 * @author beom
 */
@Controller
@RequestMapping(EimsController.URI)
public class EimsController
{
  public static final String URI = "/igate/eims" ;

  public static final ExecutorService executorService = Executors.newWorkStealingPool() ;

  protected final Log logger = LogFactory.getLog(getClass()) ;

  @Autowired
  @Qualifier("metaTransactionTemplate")
  protected TransactionTemplate transactionTemplate ;

  @Autowired
  protected HttpSession httpSession ;

  @Autowired
  protected RecordService recordService ;

  @Autowired
  protected ServiceService serviceService ;

  @Autowired
  protected InterfaceService interfaceService ;

  /**
   * Parameter의 interfaceId를 조회하여 전문 생성하는 메서드
   * 
   * @param request
   * @param response
   * @throws Exception
   * @author beom, 2021. 2. 8.
   */
  @RequestMapping(method = RequestMethod.GET)
  public void get(@RequestParam String interfaceId, HttpServletResponse response) throws Exception
  {
    try
    {
      ObjectNode objectNode = marshal(interfaceId) ;
      if (null != objectNode)
      {
        response.setStatus(HttpServletResponse.SC_OK) ;

        response.setContentType("application/json") ;
        response.setCharacterEncoding(StandardCharsets.UTF_8.name()) ;

        response.getOutputStream().write(JsonMarshaller.objectMapper.writeValueAsBytes(objectNode)) ;
        response.getOutputStream().flush() ;
      }
      else
        response.setStatus(HttpServletResponse.SC_NOT_FOUND) ;
    }
    catch (Exception e)
    {
      if (logger.isWarnEnabled())
        logger.warn(e.getMessage(), e) ;

      throw e ;
    }
  }

  /**
   * eims json 전문을 받아 파싱 후, 파라미터 값에 따라 Insert, Update 진행하는 method
   * 
   * @param request
   * @param response
   * @throws Exception
   * @author beom, 2021. 2. 7.
   */
  @RequestMapping(method = RequestMethod.POST)
  public void save(HttpServletRequest request, HttpServletResponse response) throws Exception
  {
    try
    {
      List<Record> records = new LinkedList<>() ;
      List<Service> services = new LinkedList<>() ;
      List<Interface> interfaces = new LinkedList<>() ;

      for (Object object : unmarshal(request))
        if (object instanceof Record)
          records.add((Record) object) ;
        else if (object instanceof Service)
          services.add((Service) object) ;
        else if (object instanceof Interface)
          interfaces.add((Interface) object) ;

      List<Runnable> runnables = new LinkedList<Runnable>() ;
      Map<String, Record> recordAfters = new HashMap<>() ;
      Map<String, Service> serviceAfters = new HashMap<>() ;
      Map<String, Interface> interfaceAfters = new HashMap<>() ;

      // 권한정보 우회
      httpSession.setMigration(true) ;

      transactionTemplate.execute(new TransactionCallback<Object>()
      {
        @Override
        public Object doInTransaction(TransactionStatus status)
        {
          for (Record record : records)
            try
            {
              Record sourceRecord = recordService.get(record.getRecordId()) ;
              if (null != sourceRecord)
                recordService.update(record, sourceRecord) ;
              else
                recordService.insert(record) ;

              recordAfters.put(record.getRecordId(), sourceRecord) ;
            }
            catch (RuntimeException e)
            {
              throw e ;
            }
            catch (Exception e)
            {
              throw new RuntimeException(e) ;
            }

          for (Service service : services)
            try
            {
              Service sourceService = serviceService.get(service.getServiceId()) ;
              if (null != sourceService)
                runnables.add(serviceService.update(service, sourceService)) ;
              else
                serviceService.insert(service) ;

              serviceAfters.put(service.getServiceId(), sourceService) ;
            }
            catch (RuntimeException e)
            {
              throw e ;
            }
            catch (Exception e)
            {
              throw new RuntimeException(e) ;
            }

          for (Interface interfaceMeta : interfaces)
            try
            {
              Interface sourceInterface = interfaceService.get(interfaceMeta.getInterfaceId()) ;
              if (null != sourceInterface)
                runnables.add(interfaceService.update(interfaceMeta, sourceInterface)) ;
              else
                interfaceService.insert(interfaceMeta) ;

              interfaceAfters.put(interfaceMeta.getInterfaceId(), sourceInterface) ;
            }
            catch (RuntimeException e)
            {
              throw e ;
            }
            catch (Exception e)
            {
              throw new RuntimeException(e) ;
            }

          return null ;
        }
      }) ;

      for (Record record : records)
      {
        Record sourceRecord = recordAfters.get(record.getRecordId()) ;

        executorService.execute(() ->
        {
          try
          {
            if (null != sourceRecord)
              recordService.afterUpdated(record, sourceRecord, new ExtendedModelMap()) ;
            else
              recordService.afterInserted(record, new ExtendedModelMap()) ;
          }
          catch (Exception e)
          {
            if (logger.isWarnEnabled())
              logger.warn(e.getMessage(), e) ;
          }
        }) ;
      }

      for (Service service : services)
      {
        Service sourceService = serviceAfters.get(service.getServiceId()) ;

        executorService.execute(() ->
        {
          try
          {
            if (null != sourceService)
              serviceService.afterUpdated(service, sourceService, new ExtendedModelMap()) ;
            else
              serviceService.afterInserted(service, new ExtendedModelMap()) ;
          }
          catch (Exception e)
          {
            if (logger.isWarnEnabled())
              logger.warn(e.getMessage(), e) ;
          }
        }) ;
      }

      for (Interface interfaceMeta : interfaces)
      {
        Interface sourceInterface = interfaceAfters.get(interfaceMeta.getInterfaceId()) ;

        executorService.execute(() ->
        {
          try
          {
            if (null != sourceInterface)
              interfaceService.afterUpdated(interfaceMeta, sourceInterface, new ExtendedModelMap()) ;
            else
              interfaceService.afterInserted(interfaceMeta, new ExtendedModelMap()) ;
          }
          catch (Exception e)
          {
            if (logger.isWarnEnabled())
              logger.warn(e.getMessage(), e) ;
          }
        }) ;
      }

      for (Runnable runnable : runnables)
        executorService.execute(runnable) ;

      response.setStatus(HttpServletResponse.SC_OK) ;
    }
    catch (Exception e)
    {
      if (logger.isWarnEnabled())
        logger.warn(e.getMessage(), e) ;

      throw e ;
    }
  }

  /**
   * eims delete request를 받아, 파라미터(interfaceId)로 받은 interface를 delete 하는 method
   * 
   * @param request
   * @param response
   * @throws Exception
   * @author beom, 2021. 2. 7.
   */
  @RequestMapping(method = RequestMethod.DELETE)
  public void delete(@RequestParam String interfaceId, HttpServletResponse response) throws Exception
  {
    try
    {
      Interface deleteInterface = interfaceService.get(interfaceId) ;
      if (null != deleteInterface)
      {
        Runnable runnable = interfaceService.delete(deleteInterface) ;
        interfaceService.afterDeleted(deleteInterface, new ExtendedModelMap()) ;
        runnable.run() ;

        for (com.inzent.igate.repository.meta.InterfaceService interfaceService : deleteInterface.getInterfaceServices())
          try
          {
            Service deleteService = serviceService.get(interfaceService.getPk().getServiceId()) ;
            Runnable runnable2 = serviceService.delete(deleteService) ;
            serviceService.afterDeleted(deleteService, new ExtendedModelMap()) ;
            runnable2.run() ;
          }
          catch (Exception e)
          {
            if (logger.isWarnEnabled())
              logger.warn(e.getMessage(), e) ;
          }
      }
      else
        response.setStatus(HttpServletResponse.SC_NOT_FOUND) ;
    }
    catch (Exception e)
    {
      if (logger.isWarnEnabled())
        logger.warn(e.getMessage(), e) ;

      throw e ;
    }
  }

  protected ObjectNode marshal(String interfaceId) throws Exception
  {
    Interface interfaceMeta = interfaceService.get(interfaceId) ;
    if (null != interfaceMeta)
    {
      ObjectNode objectNode = JsonMarshaller.objectMapper.createObjectNode() ;

      ArrayNode serviceNode = JsonMarshaller.objectMapper.createArrayNode() ;
      for (com.inzent.igate.repository.meta.InterfaceService interfaceService : interfaceMeta.getInterfaceServices())
      {
        Service service = serviceService.get(interfaceService.getPk().getServiceId()) ;
        serviceService.formalize(service) ;
        serviceNode.add(JsonMarshaller.marshalToJsonNode(service)) ;
      }
      objectNode.set("service", serviceNode) ;

      ArrayNode interfaceNode = JsonMarshaller.objectMapper.createArrayNode() ;
      interfaceService.formalize(interfaceMeta) ;
      objectNode.set("interface", interfaceNode.add(JsonMarshaller.marshalToJsonNode(interfaceMeta))) ;

      return objectNode ;
    }
    else
      return null ;
  }

  protected List<Object> unmarshal(HttpServletRequest request) throws Exception
  {
    List<Object> objects = new LinkedList<>() ;

    ObjectNode objectNode = (ObjectNode) JsonMarshaller.objectMapper.readTree(
        new InputStreamReader(request.getInputStream(), StringUtils.defaultString(request.getCharacterEncoding(), StandardCharsets.UTF_8.name()))) ;

    JsonNode jsonNode = objectNode.get("record") ;
    if (jsonNode instanceof ArrayNode)
    {
      ArrayNode recordNode = (ArrayNode) jsonNode ;
      for (int idx = 0 ; recordNode.size() > idx ; idx++)
      {
        Record record = JsonMarshaller.unmarshal(recordNode.get(idx), Record.class) ;
        recordService.unformalize(record, new MapBindingResult(new HashMap(), "record"), new ExtendedModelMap()) ;
        objects.add(record) ;
      }
    }

    jsonNode = objectNode.get("service") ;
    if (jsonNode instanceof ArrayNode)
    {
      ArrayNode serviceNode = (ArrayNode) jsonNode ;
      for (int idx = 0 ; serviceNode.size() > idx ; idx++)
      {
        Service service = JsonMarshaller.unmarshal(serviceNode.get(idx), Service.class) ;
        serviceService.unformalize(service, new MapBindingResult(new HashMap(), "service"), new ExtendedModelMap()) ;
        objects.add(service) ;
      }
    }

    jsonNode = objectNode.get("interface") ;
    if (jsonNode instanceof ArrayNode)
    {
      ArrayNode interfaceNode = (ArrayNode) jsonNode ;
      for (int idx = 0 ; interfaceNode.size() > idx ; idx++)
      {
        Interface interfaceMeta = JsonMarshaller.unmarshal(interfaceNode.get(idx), Interface.class) ;
        interfaceService.unformalize(interfaceMeta, new MapBindingResult(new HashMap(), "interface"), new ExtendedModelMap()) ;
        objects.add(interfaceMeta) ;
      }
    }

    return objects ;
  }
}