CLASS zcl_itab_to_xlsx DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    CLASS-METHODS convert
      IMPORTING itab             TYPE REF TO data
      RETURNING VALUE(xlsx_file) TYPE xstring
      RAISING   cx_salv_msg.

  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.


CLASS zcl_itab_to_xlsx IMPLEMENTATION.
  METHOD convert.
    ASSIGN itab->* TO FIELD-SYMBOL(<data>).
    cl_salv_table=>factory( IMPORTING r_salv_table = DATA(alv)
                            CHANGING  t_table      = <data> ).
    DATA(field_catalog) = cl_salv_controller_metadata=>get_lvc_fieldcatalog(
                              r_columns      = alv->get_columns( )
                              r_aggregations = alv->get_aggregations( ) ).
    cl_salv_bs_lex=>export_from_result_data_table(
      EXPORTING is_format            = if_salv_bs_lex_format=>mc_format_xlsx
                ir_result_data_table = cl_salv_ex_util=>factory_result_data_table( r_data         = itab
                                                                                   t_fieldcatalog = field_catalog )
      IMPORTING er_result_file       = xlsx_file ).
  ENDMETHOD.
ENDCLASS.
