CLASS zcl_rsv_util DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CONSTANTS end_of_value TYPE xstring VALUE 'FF'.
    CONSTANTS null_value   TYPE xstring VALUE 'FE'.
    CONSTANTS end_of_row   TYPE xstring VALUE 'FD'.

    DATA rsv         TYPE STANDARD TABLE OF xstringtab.
    DATA rsv_decoded TYPE STANDARD TABLE OF stringtab.

    TYPES encode_tab TYPE STANDARD TABLE OF stringtab.

    METHODS decode_rsv
      IMPORTING rsv_xstring TYPE xstring.

    METHODS encode_rsv
      IMPORTING encode_tab         TYPE encode_tab
      RETURNING VALUE(rsv_xstring) TYPE xstring.
ENDCLASS.


CLASS zcl_rsv_util IMPLEMENTATION.
  METHOD decode_rsv.
    DATA rows         TYPE xstringtab.
    DATA row_strings  TYPE stringtab.
    DATA row_xstrings TYPE xstringtab.

    SPLIT rsv_xstring AT end_of_row INTO TABLE rows IN BYTE MODE.
    LOOP AT rows ASSIGNING FIELD-SYMBOL(<row>).
      CLEAR row_strings.
      SPLIT <row> AT end_of_value INTO TABLE row_xstrings IN BYTE MODE.
      LOOP AT row_xstrings ASSIGNING FIELD-SYMBOL(<row_xstring>).
        IF <row_xstring> = null_value.
          CLEAR <row_xstring>.
        ENDIF.
        APPEND cl_abap_codepage=>convert_from( source = <row_xstring> ) TO row_strings.
      ENDLOOP.
      APPEND row_xstrings TO rsv.
      APPEND row_strings TO rsv_decoded.
    ENDLOOP.
  ENDMETHOD.

  METHOD encode_rsv.
    LOOP AT encode_tab ASSIGNING FIELD-SYMBOL(<encode_row>).
      LOOP AT <encode_row> ASSIGNING FIELD-SYMBOL(<encode_value>).
        rsv_xstring = |{ rsv_xstring }{ cl_abap_codepage=>convert_to( source = <encode_value> ) }{ end_of_value }|.
      ENDLOOP.
      rsv_xstring = |{ rsv_xstring }{ end_of_row }|.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
