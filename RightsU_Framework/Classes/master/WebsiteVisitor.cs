using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using UTOFrameWork.FrameworkClasses;

public class WebsiteVisitor
{

    private string sessionId;

    public string SessionId
    {

        get { return sessionId; }

        set { sessionId = value; }

    }



    public string IpAddress
    {

        get { return ipAddress; }

        set { ipAddress = value; }

    }

    private string ipAddress;



    public string UrlReferrer
    {

        get { return urlReferrer; }

        set { urlReferrer = value; }

    }

    private string urlReferrer;



    public string EnterUrl
    {

        get { return enterUrl; }

        set { enterUrl = value; }

    }

    private string enterUrl;



    public string UserAgent
    {

        get { return userAgent; }

        set { userAgent = value; }

    }

    private string userAgent;



    public DateTime SessionStarted
    {

        get { return sessionStarted; }

        set { sessionStarted = value; }

    }

    private DateTime sessionStarted;


    public string UserName
    {

        get { return userName; }

        set { userName = value; }

    }

    private string userName;

    public string EntityName
    {

        get { return entityName; }

        set { entityName = value; }

    }
    public string entityName;

    public WebsiteVisitor(HttpContext context,string userNameTmp,string entityKey)
    {

        if ((context != null) && (context.Request != null) && (context.Session != null))
        {

            this.UserName = userNameTmp;

            this.sessionId = context.Session.SessionID;

            this.EntityName = entityKey;

            sessionStarted = DateTime.Now;

            userAgent = string.IsNullOrEmpty(context.Request.UserAgent) ? "" : context.Request.UserAgent;

            ipAddress = context.Request.UserHostAddress;
            
            if (context.Request.UrlReferrer != null)
            {

                urlReferrer = string.IsNullOrEmpty(context.Request.UrlReferrer.OriginalString) ? "" : context.Request.UrlReferrer.OriginalString;

            }

            enterUrl = string.IsNullOrEmpty(context.Request.Url.OriginalString) ? "" : context.Request.Url.OriginalString;

        }

    }



}

