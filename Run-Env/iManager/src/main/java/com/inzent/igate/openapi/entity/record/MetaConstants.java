package com.inzent.igate.openapi.entity.record;

import java.util.LinkedHashMap ;
import java.util.Map ;

import org.apache.commons.collections4.MapUtils ;

import com.inzent.igate.repository.meta.Field ;

public class MetaConstants
{
  public static final Map<Character, String> FIELD_TYPES ;
  public static final Map<String, Character> FIELD_TYPES_INVERT ;

  public static final Map<Character, String> FIELD_ARRAYTYPES ;
  public static final Map<String, Character> FIELD_ARRAYTYPES_INVERT ;

  public static final String EXCEL_HEADER = "Header" ; //$NON-NLS-1$
  public static final String EXCEL_REFER = "Referance" ; //$NON-NLS-1$
  public static final String EXCEL_INDIVI = "Individual" ; //$NON-NLS-1$  
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