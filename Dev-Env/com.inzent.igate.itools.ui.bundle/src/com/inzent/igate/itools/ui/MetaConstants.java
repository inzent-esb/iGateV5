package com.inzent.igate.itools.ui ;

import java.util.LinkedHashMap ;
import java.util.Map ;

import org.apache.commons.collections4.MapUtils ;

import com.inzent.igate.repository.meta.Field ;

public class MetaConstants
{
  public static String MESSAGE_SUMMARYINFO          = "\n\n   ◈ Total : %d , Success : %d , Fail : %s"; //    ◈ Total : 10 , Success : 7 , Fail : 3
  public static String MESSAGE_ENTITY_TYPE          = "\n\n【 %s 】";                 //【 타입 】

  //export
  public static String MESSAGE_EXPORT_PATH          = "\n └ Export Path : %s";      // └ Export Path : 경로
  public static String MESSAGE_EXPORT_SUCCESS       = "\n   ▷ %s.%s : %s";           //   ▷id.확장자 : 성공
  public static String MESSAGE_EXPORT_FAIL          = "\n   ▶ %s.%s : %s [ %s ]";    //   ▶id.확장자 : 실패 [오류내용]
  public static String FILE_EXTENDER_EXCEL          = "xlsx";
  public static String FILE_EXTENDER_JSON           = "json";
  public static String FILE_EXTENDER_XML            = "xml";

  //import
  public static String MESSAGE_IMPORT_SUCCESS           = "\n   ▷ %s : %s";             //   ▷ 파일명 : 성공
  public static String MESSAGE_IMPORT_FAIL              = "\n   ▶ %s : %s [ %s ]";      //   ▶ 파일명 : 실패 [오류내용]
  public static String MESSAGE_IMPORT_FAIL_ENCRYPTION   = "\n   ▶ %s : %s";             //   ▶ 파일명 : 암복호화 실패메시지
  public static String MESSAGE_OPEN_EDITOR_INFO         = "\n# %d [ %s ] %s";           //# 1 [ Operation ] AOP_TEST
  public static String FILTER_FILE_EXTENDER_EXCEL1      = "*.xlsx";
  public static String FILTER_FILE_EXTENDER_EXCEL2      = "*.xls";
  public static String FILTER_FILE_EXTENDER_JSON        = "*.json";
  public static String FILTER_FILE_EXTENDER_XML         = "*.xml";

  
  public static final Map<Character, String> FIELD_TYPES ;
  public static final Map<String, Character> FIELD_TYPES_INVERT ;

  public static final Map<Character, String> FIELD_ARRAYTYPES ;
  public static final Map<String, Character> FIELD_ARRAYTYPES_INVERT ;

  public static final String EXCEL_HEADER = "Header" ; //$NON-NLS-1$
  public static final String EXCEL_REFER = "Referance" ; //$NON-NLS-1$
  public static final String EXCEL_INDIVI = "Individual" ; //$NON-NLS-1$

  public static final String SUBRECORD_DELIMETER = "@" ; //$NON-NLS-1$

  public static final char PRIVATEYN_YN_Y = 'Y' ; // $NON-NLS-1$
  public static final char PRIVATEYN_YN_N = 'N' ; // $NON-NLS-1$

  public static final int EXCEL_SINGLE_MODE = 1 ;
  public static final int EXCEL_MULTI_MODE = 2 ;
  public static final int EXCEL_GROUP_MODE = 3 ;
  
  public static final String OPERATION_ATTRIBUTE_OPERATIONGROUP ="operationGroup";
  public static final String OPERATION_ATTRIBUTE_PRIVILEGEID ="privilegeId";
  public static final String OPERATION_ATTRIBUTE_PRIVATEYN ="privateYn";
  public static final String OPERATION_ATTRIBUTE_OPERATIONLOGLEVEL ="operationLogLevel";
  public static final String OPERATION_ATTRIBUTE_XATRANSACTIONATTRIBUTE ="xaTransactionAttribute";
  
  static
  {
    FIELD_TYPES = new LinkedHashMap<Character, String>() ;
    FIELD_TYPES.put(Field.TYPE_BYTE, "Byte") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_SHORT, "Short") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_INT, "Int") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_LONG, "Long") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_FLOAT, "Float") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_DOUBLE, "Double") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_TIMESTAMP, "TimeStamp") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_STRING, "String") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_NUMERIC, "Numeric") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_PACKED_DECIMAL, "PackedDecimal") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_RAW, "Raw") ; //$NON-NLS-1$
    FIELD_TYPES.put(Field.TYPE_RECORD, "Record") ; //$NON-NLS-1$
    FIELD_TYPES_INVERT = MapUtils.invertMap(FIELD_TYPES) ;

    FIELD_ARRAYTYPES = new LinkedHashMap<Character, String>() ;
    FIELD_ARRAYTYPES.put(Field.ARRAY_NOT, "Not") ; //$NON-NLS-1$
    FIELD_ARRAYTYPES.put(Field.ARRAY_FIXED, "Fixed") ; //$NON-NLS-1$
    FIELD_ARRAYTYPES.put(Field.ARRAY_VARIABLE, "Variable") ; //$NON-NLS-1$
    FIELD_ARRAYTYPES_INVERT = MapUtils.invertMap(FIELD_ARRAYTYPES) ;
  }
}