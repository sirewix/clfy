m4_define(`import', `m4_dnl
  m4_ifdef(`$1_m4_file', `', ``Included from $1'
    m4_include($1)
  ')m4_dnl
  m4_define(`$1_m4_file')m4_dnl
')m4_dnl
m4_changecom(`##', `')m4_dnl
