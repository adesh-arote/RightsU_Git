using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Configuration;
using UTOFrameWork.FrameworkClasses;
using System.Net;
using Microsoft.Reporting.WebForms;
using System.Security.Principal;
/// <summary>
/// Summary description for ReporitngService
/// </summary>
[Serializable]
public sealed class ReportServerCredentials : IReportServerCredentials
{
    private string _userName;
    private string _password;
    private string _domain;

    public ReportServerCredentials(string userName, string password, string domain)
    {
        _userName = userName;
        _password = password;
        _domain = domain;
    }

    public WindowsIdentity ImpersonationUser
    {
        get
        {
            // Use default identity.
            return null;
        }
    }

    public ICredentials NetworkCredentials
    {
        get
        {
            // Use default identity.
            return new NetworkCredential(_userName, _password, _domain);
        }
    }

    public bool GetFormsCredentials(out Cookie authCookie,
                out string userName, out string password,
                out string authority)
    {
        authCookie = null;
        userName = null;
        password = null;
        authority = null;

        // Not using form credentials
        return false;
    }

}
