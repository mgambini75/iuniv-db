CREATE OR REPLACE PACKAGE NOTIFICATORE
IS
   FUNCTION SendNotification (p_Message IN VARCHAR2, p_UserName IN VARCHAR2, p_Badge in number default 0, p_authkey  IN VARCHAR2 default null, p_authcode  IN VARCHAR2 default null) RETURN VARCHAR2; 
   FUNCTION SendNotificationLN (p_Message IN VARCHAR2, p_MessageEng IN VARCHAR2, p_UserName IN VARCHAR2, p_Badge in number default 0, p_authkey  IN VARCHAR2 default null, p_authcode  IN VARCHAR2 default null) RETURN VARCHAR2;
   procedure help;
END NOTIFICATORE;
/
