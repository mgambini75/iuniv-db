CREATE OR REPLACE PACKAGE APEX_UTILS as
  procedure help;
  procedure db_check;
  procedure autovalid;
  procedure show_all_fk(nome_tabella in varchar2 default null);
  procedure show_synonyms(nome_tabella in varchar2 default null);
  procedure set_foreign(stato in varchar2 default null);
  procedure set_trigger(stato in varchar2 default null);
  procedure drop_fk (ObjectName  in varchar2);
  procedure drop_table(tabella in varchar2);
  procedure drop_sequence(nome_sequence in varchar2);
  procedure reset_seq (p_seq_name IN VARCHAR2, p_start_num IN NUMBER DEFAULT 1);
  procedure align_table_seq (p_seq_name IN VARCHAR2, p_tab_name IN VARCHAR2, p_key IN VARCHAR2);
  procedure drop_procedure(procedura in varchar2);
  PROCEDURE rename_ck (p_nome_tabella IN VARCHAR2 DEFAULT NULL, p_output IN CHAR DEFAULT 'N');
end apex_utils;
/
