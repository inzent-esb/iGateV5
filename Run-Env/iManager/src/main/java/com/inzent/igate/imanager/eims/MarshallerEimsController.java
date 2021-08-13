package com.inzent.igate.imanager.eims ;

import java.io.InputStreamReader ;
import java.nio.charset.StandardCharsets ;
import java.util.Collection ;
import java.util.HashMap ;
import java.util.LinkedList ;
import java.util.List ;

import javax.naming.NameNotFoundException ;
import javax.servlet.http.HttpServletRequest ;
import javax.servlet.http.HttpServletResponse ;

import org.apache.commons.lang3.StringUtils ;
import org.springframework.stereotype.Controller ;
import org.springframework.ui.ExtendedModelMap ;
import org.springframework.validation.MapBindingResult ;
import org.springframework.web.bind.annotation.RequestMapping ;

import com.fasterxml.jackson.databind.JsonNode ;
import com.fasterxml.jackson.databind.node.ArrayNode ;
import com.fasterxml.jackson.databind.node.ObjectNode ;
import com.inzent.igate.repository.meta.Interface ;
import com.inzent.igate.repository.meta.Record ;
import com.inzent.igate.repository.meta.Service ;
import com.inzent.imanager.marshaller.JsonMarshaller ;

/**
 * <code>MarshallerEimsController</code> eims 전문 받아 update, insert, delete 수행하는 controller
 *
 * @since 2021. 2. 7.
 * @version 5.0
 * @author beom
 */
@Controller
@RequestMapping(MarshallerEimsController.URI)
public class MarshallerEimsController extends AbstractEimsController
{
  public static final String URI = "/igate/eimsMarshaller" ;

  @Override
  protected void makeErrorResponse(HttpServletResponse response, HttpServletRequest request, Throwable throwable)
  {
    response.setStatus(throwable instanceof NameNotFoundException ? HttpServletResponse.SC_NOT_FOUND : HttpServletResponse.SC_INTERNAL_SERVER_ERROR) ;

    if (logger.isWarnEnabled())
      logger.warn(throwable.getMessage(), throwable) ;
  }

  @Override
  protected Collection<Object> parseGetRequest(HttpServletRequest request) throws Exception
  {
    LinkedList<Object> list = new LinkedList<>() ;

    for (String interfaceId : request.getParameterValues("interfaceId"))
    {
      Interface interfaceMeta = interfaceService.get(interfaceId) ;
      if (null == interfaceMeta)
        throw new NameNotFoundException("Not Founded - " + interfaceId) ;

      list.add(interfaceMeta) ;
    }

    return list ;
  }

  @Override
  protected void makeGetResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception
  {
    ObjectNode objectNode = JsonMarshaller.objectMapper.createObjectNode() ;
    ArrayNode serviceNode = JsonMarshaller.objectMapper.createArrayNode() ;
    ArrayNode interfaceNode = JsonMarshaller.objectMapper.createArrayNode() ;

    objectNode.set("service", serviceNode) ;
    objectNode.set("interface", interfaceNode) ;

    for (Interface interfaceMeta : interfaces)
    {
      for (com.inzent.igate.repository.meta.InterfaceService interfaceService : interfaceMeta.getInterfaceServices())
      {
        Service service = serviceService.get(interfaceService.getPk().getServiceId()) ;
        serviceService.formalize(service) ;
        serviceNode.add(JsonMarshaller.marshalToJsonNode(service)) ;
      }

      interfaceService.formalize(interfaceMeta) ;
      interfaceNode.add(JsonMarshaller.marshalToJsonNode(interfaceMeta)) ;
    }

    response.setStatus(HttpServletResponse.SC_OK) ;

    response.setContentType("application/json") ;
    response.setCharacterEncoding(StandardCharsets.UTF_8.name()) ;

    response.getOutputStream().write(JsonMarshaller.objectMapper.writeValueAsBytes(objectNode)) ;
    response.getOutputStream().flush() ;
  }

  @Override
  protected Collection<Object> parsePostRequest(HttpServletRequest request) throws Exception
  {
    List<Object> objects = new LinkedList<>() ;

    ObjectNode objectNode = (ObjectNode) JsonMarshaller.objectMapper.readTree(
        new InputStreamReader(request.getInputStream(), StringUtils.defaultString(request.getCharacterEncoding(), StandardCharsets.UTF_8.name()))) ;

    JsonNode jsonNode = objectNode.get("service") ;
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

  @Override
  protected void makePostResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces) throws Exception
  {
    response.setStatus(HttpServletResponse.SC_OK) ;
  }

  @Override
  protected Collection<Object> parseDeleteRequest(HttpServletRequest request) throws Exception
  {
    return parseGetRequest(request) ;
  }

  @Override
  protected void makeDeleteResponse(HttpServletResponse response, HttpServletRequest request, Collection<Record> records, Collection<Service> services, Collection<Interface> interfaces)
  {
    response.setStatus(HttpServletResponse.SC_OK) ;
  }
}