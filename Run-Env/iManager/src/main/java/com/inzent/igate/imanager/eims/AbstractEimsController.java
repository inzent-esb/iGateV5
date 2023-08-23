package com.inzent.igate.imanager.eims ;

import java.util.Collection ;
import java.util.HashMap ;
import java.util.LinkedList ;
import java.util.List ;
import java.util.Map ;
import java.util.concurrent.ExecutorService ;
import java.util.concurrent.Executors ;

import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.apache.commons.logging.Log ;
import org.apache.commons.logging.LogFactory ;
import org.springframework.beans.factory.annotation.Autowired ;
import org.springframework.beans.factory.annotation.Qualifier ;
import org.springframework.transaction.TransactionStatus ;
import org.springframework.transaction.support.TransactionCallback ;
import org.springframework.transaction.support.TransactionTemplate ;
import org.springframework.web.bind.annotation.RequestMapping ;
import org.springframework.web.bind.annotation.RequestMethod ;

import com.inzent.igate.imanager.CachedMetaEntityService ;
import com.inzent.igate.openapi.entity.interfaces.InterfaceService ;
import com.inzent.igate.openapi.entity.mapping.MappingService ;
import com.inzent.igate.openapi.entity.record.RecordService ;
import com.inzent.igate.openapi.entity.service.ServiceService ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.InterfaceRecognize ;
import com.inzent.igate.repository.meta.RecognizePK ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.imanager.controller.HttpSession ;

/**
 * <code>EimsController</code> eims 전문 받아 update, insert, delete 수행하는 controller
 *
 * @since 2021. 2. 7.
 * @version 5.0
 * @author beom
 */
public abstract class AbstractEimsController
{
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
  
  @Autowired
  protected MappingService mappingService ;

  @Autowired
  @Qualifier("interfaceRecognizeService")
  protected CachedMetaEntityService<RecognizePK, InterfaceRecognize> interfaceRecognizeService ;

  /**
   * Parameter의 interfaceId를 조회하여 전문 생성하는 메서드
   * 
   * @param request
   * @param response
   * @throws Exception
   * @author beom, 2021. 2. 8.
   */
  @RequestMapping(method = RequestMethod.GET)
  public void get(HttpServletRequest request, HttpServletResponse response) throws Exception
  {
    try
    {
      List<Record> records = new LinkedList<>() ;
      List<Service> services = new LinkedList<>() ;
      List<Interface> interfaces = new LinkedList<>() ;

      for (Object object : parseGetRequest(request))
        if (object instanceof Interface)
          interfaces.add((Interface) object) ;
        else if (object instanceof Service)
          services.add((Service) object) ;
        else if (object instanceof Record)
          records.add((Record) object) ;

      makeGetResponse(response, request, records, services, interfaces) ;
    }
    catch (Throwable t)
    {
      makeErrorResponse(response, request, t) ;
    }
  }

  /**
   * eims 전문을 받아 파싱 후, 파라미터 값에 따라 Insert, Update 진행하는 method
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
      List<InterfaceRecognize> interfaceRecognizes = new LinkedList<>() ;

      for (Object object : parsePostRequest(request))
        if (object instanceof Interface)
          interfaces.add((Interface) object) ;
        else if (object instanceof Service)
          services.add((Service) object) ;
        else if (object instanceof Record)
          records.add((Record) object) ;

      List<Runnable> runnables = new LinkedList<Runnable>() ;
      Map<String, Record> recordAfters = new HashMap<>() ;
      Map<String, Service> serviceAfters = new HashMap<>() ;
      Map<String, Interface> interfaceAfters = new HashMap<>() ;
      Map<RecognizePK, InterfaceRecognize> interfaceRecognizeAfters = new HashMap<>() ;

      // 권한정보 우회
      httpSession.setMigration(true) ;

      transactionTemplate.execute(new TransactionCallback<Object>()
      {
        @Override
        public Object doInTransaction(TransactionStatus status)
        {
          try
          {
            for (Record record : records)
            {
              Record sourceRecord = recordService.get(record.getRecordId()) ;
              if (null != sourceRecord)
              {
                recordService.evict(sourceRecord) ;
                recordService.update(record, sourceRecord) ;
              }
              else
                recordService.insert(record) ;

              recordAfters.put(record.getRecordId(), sourceRecord) ;
            }

            for (Service service : services)
            {
              Service sourceService = serviceService.get(service.getServiceId()) ;
              if (null != sourceService)
              {
                serviceService.evict(sourceService) ;
                runnables.add(serviceService.update(service, sourceService)) ;
              }
              else
                serviceService.insert(service) ;

              serviceAfters.put(service.getServiceId(), sourceService) ;
            }

            for (Interface interfaceMeta : interfaces)
            {
              List<InterfaceRecognize> subInterfaceRecognizes = interfaceMeta.getInterfaceRecognizes() ;
              interfaceMeta.setInterfaceRecognizes(null) ;

              Interface sourceInterface = interfaceService.get(interfaceMeta.getInterfaceId()) ;
              if (null != sourceInterface)
              {
                interfaceService.evict(sourceInterface) ;
                runnables.add(interfaceService.update(interfaceMeta, sourceInterface)) ;
              }
              else
                interfaceService.insert(interfaceMeta) ;

              interfaceAfters.put(interfaceMeta.getInterfaceId(), sourceInterface) ;

              for (InterfaceRecognize interfaceRecognize : subInterfaceRecognizes)
              {
                interfaceRecognizes.add(interfaceRecognize) ;

                InterfaceRecognize sourceInterfaceRecognize = interfaceRecognizeService.get(interfaceRecognize.getPk()) ;
                if (null != sourceInterfaceRecognize) {
                  interfaceRecognizeService.evict(sourceInterfaceRecognize);
                  interfaceRecognizeService.update(interfaceRecognize, sourceInterfaceRecognize) ;
                }
                else
                  interfaceRecognizeService.insert(interfaceRecognize) ;

                interfaceRecognizeAfters.put(interfaceRecognize.getPk(), sourceInterfaceRecognize) ;
              }
            }
          }
          catch (RuntimeException | Error e)
          {
            throw e ;
          }
          catch (Throwable t)
          {
            throw new RuntimeException(t) ;
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
              recordService.afterUpdated(record, sourceRecord) ;
            else
              recordService.afterInserted(record) ;
          }
          catch (Throwable t)
          {
            if (logger.isWarnEnabled())
              logger.warn(t.getMessage(), t) ;
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
              serviceService.afterUpdated(service, sourceService) ;
            else
              serviceService.afterInserted(service) ;
          }
          catch (Throwable t)
          {
            if (logger.isWarnEnabled())
              logger.warn(t.getMessage(), t) ;
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
              interfaceService.afterUpdated(interfaceMeta, sourceInterface) ;
            else
              interfaceService.afterInserted(interfaceMeta) ;
          }
          catch (Throwable t)
          {
            if (logger.isWarnEnabled())
              logger.warn(t.getMessage(), t) ;
          }
        }) ;
      }

      for (InterfaceRecognize interfaceRecognize : interfaceRecognizes)
      {
        InterfaceRecognize sourceInterfaceRecognize = interfaceRecognizeAfters.get(interfaceRecognize.getPk()) ;

        executorService.execute(() ->
        {
          try
          {
            if (null != sourceInterfaceRecognize)
              interfaceRecognizeService.afterUpdated(interfaceRecognize, sourceInterfaceRecognize) ;
            else
              interfaceRecognizeService.afterInserted(interfaceRecognize) ;
          }
          catch (Throwable t)
          {
            if (logger.isWarnEnabled())
              logger.warn(t.getMessage(), t) ;
          }
        }) ;
      }

      for (Runnable runnable : runnables)
        executorService.execute(runnable) ;

      makePostResponse(response, request, records, services, interfaces) ;
    }
    catch (Throwable t)
    {
      makeErrorResponse(response, request, t) ;
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
  public void delete(HttpServletRequest request, HttpServletResponse response) throws Exception
  {
    try
    {
      List<Record> records = new LinkedList<>() ;
      List<Service> services = new LinkedList<>() ;
      List<Interface> interfaces = new LinkedList<>() ;

      for (Object object : parseDeleteRequest(request))
        if (object instanceof Interface)
          interfaces.add((Interface) object) ;
        else if (object instanceof Service)
          services.add((Service) object) ;
        else if (object instanceof Record)
          records.add((Record) object) ;

      List<Runnable> runnables = new LinkedList<Runnable>() ;

      transactionTemplate.execute(new TransactionCallback<Object>()
      {
        @Override
        public Object doInTransaction(TransactionStatus status)
        {
          try
          {
            for (Interface interfaceMeta : interfaces)
              runnables.add(interfaceService.delete(interfaceMeta)) ;

            for (Service service : services)
              runnables.add(serviceService.delete(service)) ;

            for (Record record : records)
              recordService.delete(record) ;
          }
          catch (RuntimeException | Error e)
          {
            throw e ;
          }
          catch (Throwable t)
          {
            throw new RuntimeException(t) ;
          }

          return null ;
        }
      }) ;

      for (Interface interfaceMeta : interfaces)
        executorService.execute(() ->
        {
          try
          {
            interfaceService.afterDeleted(interfaceMeta) ;
          }
          catch (Throwable t)
          {
            if (logger.isWarnEnabled())
              logger.warn(t.getMessage(), t) ;
          }
        }) ;

      for (Service service : services)
        executorService.execute(() ->
        {
          try
          {
            serviceService.afterDeleted(service) ;
          }
          catch (Throwable t)
          {
            if (logger.isWarnEnabled())
              logger.warn(t.getMessage(), t) ;
          }
        }) ;

      for (Record record : records)
        executorService.execute(() ->
        {
          try
          {
            recordService.afterDeleted(record) ;
          }
          catch (Throwable t)
          {
            if (logger.isWarnEnabled())
              logger.warn(t.getMessage(), t) ;
          }
        }) ;

      makeDeleteResponse(response, request, records, services, interfaces) ;
    }
    catch (Throwable t)
    {
      makeErrorResponse(response, request, t) ;
    }
  }

  protected abstract void makeErrorResponse(HttpServletResponse response, HttpServletRequest request, Throwable throwable) throws Exception ;

  protected abstract Collection<Object> parseGetRequest(HttpServletRequest request) throws Exception ;
  protected abstract void makeGetResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception ;

  protected abstract Collection<Object> parsePostRequest(HttpServletRequest request) throws Exception ;
  protected abstract void makePostResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception ;

  protected abstract Collection<Object> parseDeleteRequest(HttpServletRequest request) throws Exception ;
  protected abstract void makeDeleteResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception ;
}