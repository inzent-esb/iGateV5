import java.io.IOException ;

import org.junit.jupiter.api.AfterAll ;
import org.junit.jupiter.api.BeforeAll ;
import org.junit.jupiter.api.Test ;

import com.inzent.igate.adapter.AdapterParameter ;
import com.inzent.igate.debug.DebugEnvironment ;
import com.inzent.igate.debug.DebugUtils ;
import com.inzent.igate.message.MessageBeans ;
import com.inzent.igate.message.MessageConverter ;
import com.inzent.igate.message.Record ;

public class DebugIGate
{
  @BeforeAll
  public static void start() throws IOException
  {
    DebugEnvironment.start() ;
  }

  @Test
  public void degugInterfaceMessageConverter() throws Exception
  {
    Record record = DebugUtils.parseInterface("I_TER", "IF_TER_COM_0010", DebugUtils.getRequestData("IF_TER_COM_0010")) ;

    System.out.println(record) ;
  }

  @Test
  public void degugServiceMessageConverter() throws Exception
  {
    Record record = DebugUtils.parseService("I_COM", "SV_COM_0010", DebugUtils.getReplyData("SV_COM_0010")) ;

    System.out.println(record) ;
  }

  @Test
  public void degugInterface() throws Exception
  {
    AdapterParameter adapterParameter = DebugUtils.executeInterface("I_TER", DebugUtils.getRequestData("IF_TER_COM_0010"), true) ;

    MessageConverter messageConverter = MessageBeans.SINGLETON.createMessageConverter(adapterParameter.getAdapter(), adapterParameter.getResponseData()) ;

    System.out.println(messageConverter.dump()) ;
  }

  @Test
  public void degugJob() throws Exception
  {
    DebugUtils.executeJob("JOP_Schedule") ;

    Thread.sleep(5 * 1000L) ;
  }

  @AfterAll
  public static void shutdown()
  {
    DebugEnvironment.shutdown() ;
  }
}
