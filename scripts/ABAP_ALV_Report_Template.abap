*&---------------------------------------------------------------------*
*& Report Z_O2C_SALES_ANALYSIS
*&---------------------------------------------------------------------*
*& Purpose: Custom ALV Report for O2C Sales Order Analysis
*&---------------------------------------------------------------------*

REPORT z_o2c_sales_analysis.

TABLES: vbak, vbap, kna1, makt.

TYPE-POOLS: slis.

*--- Data Declaration
DATA: it_salesdoc TYPE TABLE OF vbak,
      it_output   TYPE TABLE OF ty_output,
      it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_output   TYPE ty_output,
      wa_fieldcat TYPE slis_fieldcat_alv.

TYPES: BEGIN OF ty_output,
         vbeln TYPE vbak-vbeln,           "Sales Order Number
         erdat TYPE vbak-erdat,           "Order Date
         kunnr TYPE vbak-kunnr,           "Customer
         name1 TYPE kna1-name1,           "Customer Name
         netwr TYPE vbak-netwr,           "Order Value
         waerk TYPE vbak-waerk,           "Currency
         vbtyp TYPE vbak-vbtyp,           "Order Type
         status TYPE vbak-status,         "Order Status
         arktx TYPE vbap-arktx,           "Item Description
         maktx TYPE makt-maktx,           "Material Description
         kwmeng TYPE vbap-kwmeng,         "Ordered Quantity
         pricin TYPE vbap-netwr,          "Item Price
       END OF ty_output.

*--- Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: s_vbeln FOR vbak-vbeln,
                s_erdat FOR vbak-erdat,
                s_kunnr FOR vbak-kunnr.
SELECTION-SCREEN END OF BLOCK b1.

*--- Main Processing
START-OF-SELECTION.

  "Fetch Sales Orders
  SELECT vbak~vbeln vbak~erdat vbak~kunnr vbak~netwr vbak~waerk
         vbak~vbtyp vbak~status kna1~name1
    INTO TABLE it_salesdoc
    FROM vbak
    LEFT JOIN kna1 ON vbak~kunnr EQ kna1~kunnr
    WHERE vbak~vbeln IN s_vbeln
      AND vbak~erdat IN s_erdat
      AND vbak~kunnr IN s_kunnr.

  IF sy-subrc NE 0.
    MESSAGE i001 WITH 'No sales orders found'.
    STOP.
  ENDIF.

  "Fetch Sales Order Details
  SELECT vbap~vbeln vbap~posnr vbap~matnr vbap~arktx vbap~kwmeng vbap~netwr
    INTO TABLE it_salesdoc_detail
    FROM vbap
    WHERE vbeln IN (SELECT vbeln FROM it_salesdoc).

  "Fetch Material Descriptions
  SELECT matnr maktx
    INTO TABLE it_materials
    FROM makt
    WHERE matnr IN (SELECT matnr FROM it_salesdoc_detail).

  "Build Output Table
  LOOP AT it_salesdoc INTO wa_salesdoc.
    wa_output-vbeln = wa_salesdoc-vbeln.
    wa_output-erdat = wa_salesdoc-erdat.
    wa_output-kunnr = wa_salesdoc-kunnr.
    wa_output-name1 = wa_salesdoc-name1.
    wa_output-netwr = wa_salesdoc-netwr.
    wa_output-waerk = wa_salesdoc-waerk.

    "Get Item Details
    LOOP AT it_salesdoc_detail INTO wa_detail
         WHERE vbeln EQ wa_salesdoc-vbeln.
      wa_output-arktx = wa_detail-arktx.
      wa_output-kwmeng = wa_detail-kwmeng.
      wa_output-pricin = wa_detail-netwr.

      "Get Material Description
      READ TABLE it_materials INTO wa_material
           WITH KEY matnr = wa_detail-matnr.
      IF sy-subrc EQ 0.
        wa_output-maktx = wa_material-maktx.
      ENDIF.

      APPEND wa_output TO it_output.
    ENDLOOP.
  ENDLOOP.

  "Display using ALV
  PERFORM build_fieldcat.
  PERFORM display_alv.

*--- Subroutines
FORM build_fieldcat.
  DATA: wa_fcat TYPE slis_fieldcat_alv.

  wa_fcat-fieldname = 'VBELN'.
  wa_fcat-seltext_l = 'Sales Order'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fieldcat.

  wa_fcat-fieldname = 'ERDAT'.
  wa_fcat-seltext_l = 'Order Date'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fieldcat.

  wa_fcat-fieldname = 'KUNNR'.
  wa_fcat-seltext_l = 'Customer'.
  wa_fcat-outputlen = 10.
  APPEND wa_fcat TO it_fieldcat.

  wa_fcat-fieldname = 'NAME1'.
  wa_fcat-seltext_l = 'Customer Name'.
  wa_fcat-outputlen = 30.
  APPEND wa_fcat TO it_fieldcat.

  wa_fcat-fieldname = 'NETWR'.
  wa_fcat-seltext_l = 'Order Value'.
  wa_fcat-outputlen = 15.
  wa_fcat-datatype = 'CURR'.
  APPEND wa_fcat TO it_fieldcat.

  wa_fcat-fieldname = 'KWMENG'.
  wa_fcat-seltext_l = 'Quantity'.
  wa_fcat-outputlen = 12.
  APPEND wa_fcat TO it_fieldcat.

  wa_fcat-fieldname = 'PRICIN'.
  wa_fcat-seltext_l = 'Unit Price'.
  wa_fcat-outputlen = 12.
  wa_fcat-datatype = 'CURR'.
  APPEND wa_fcat TO it_fieldcat.
ENDFORM.

FORM display_alv.
  CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
    EXPORTING
      it_fieldcat = it_fieldcat
    TABLES
      t_outtab    = it_output.
ENDFORM.
