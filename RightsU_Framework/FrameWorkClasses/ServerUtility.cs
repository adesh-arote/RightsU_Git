using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.DirectoryServices;
using System.Collections;
using System.Security.Cryptography;
using System.Text;
using System.IO;

namespace UTOFrameWork.FrameworkClasses {
    /// <summary>
    /// Summary description for ServerUtility
    /// </summary>
    public class ServerUtility {

        #region --- --- Constructor --- ---

        public ServerUtility()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        #endregion

        #region --- --- Methods --- ---

        public static object validateUser(string strUserName, string strPassword)
        {
            Criteria objCriteria = new Criteria();
            Users objUser = new Users();
            ArrayList objArr;
            string strSearchString;
            objCriteria.IsSubClassRequired = true;
            objCriteria.IsPagingRequired = false;
            objCriteria.ClassRef = objUser;
            strSearchString = " and  login_name = '" + GlobalUtil.ReplaceSingleQuotes(strUserName) + "' collate SQL_Latin1_General_CP1_CS_AS and password = '" + getEncriptedStr(GlobalUtil.ReplaceSingleQuotes(strPassword)) + "' collate SQL_Latin1_General_CP1_CS_AS";
            objArr = objCriteria.Execute(strSearchString);
            if (objArr.Count > 0)
            {
                return objArr[0];
            }
            else
            {
                return null;
            }
        }
        public static object validateUserAutomate(string strUserName, string strPassword)
        {
            Criteria objCriteria = new Criteria();
            Users objUser = new Users();
            ArrayList objArr;
            string strSearchString;
            objCriteria.IsSubClassRequired = true;
            objCriteria.IsPagingRequired = false;
            objCriteria.ClassRef = objUser;
            strSearchString = " and  login_name = '" + GlobalUtil.ReplaceSingleQuotes(strUserName) + "' collate SQL_Latin1_General_CP1_CS_AS and password = '" + strPassword + "' collate SQL_Latin1_General_CP1_CS_AS";
            objArr = objCriteria.Execute(strSearchString);
            if (objArr.Count > 0)
            {
                return objArr[0];
            }
            else
            {
                return null;
            }
        }

        public static Users validateUser(string strUserName)
        {
            Criteria objCriteria = new Criteria();
            Users objUser = new Users();
            ArrayList objArr;
            string strSearchString;
            objCriteria.IsSubClassRequired = true;
            objCriteria.IsPagingRequired = false;
            objCriteria.ClassRef = objUser;
            strSearchString = " and  login_name = '" + GlobalUtil.ReplaceSingleQuotes(strUserName) + "' collate SQL_Latin1_General_CP1_CS_AS ";
            objArr = objCriteria.Execute(strSearchString);
            if (objArr.Count > 0)
            {
                return (Users)objArr[0];
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Used for LDAP of Star TV
        /// </summary>
        /// <param name="username">User Login ID in LDAP</param>
        /// <param name="pwd">Password in LDAP</param>
        /// <returns></returns>
        public static bool isAdAuthenticated(string username, string pwd)
        {
            string ldap = ConfigurationManager.AppSettings["LDAP_adLdapPath"].ToString().Trim();
            string domainAndUsername = ConfigurationManager.AppSettings["LDAP_adDomain"].ToString().Trim() + @"\" + username;

            DirectoryEntry entry = new DirectoryEntry(ldap, domainAndUsername, pwd);
            try
            {
                // Bind to the native AdsObject to force authentication.
                Object obj = entry.NativeObject;
                DirectorySearcher search = new DirectorySearcher(entry);
                search.Filter = "(SAMAccountName=" + username + ")";
                search.PropertiesToLoad.Add("cn");
                SearchResult result = search.FindOne();
                if (null == result)
                {
                    return false;
                }
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }

        public static long getDateComparisionNumber(string strDate)
        {
            string actualStr = strDate.Trim().Replace("T", "~").Replace(":", "~").Replace("-", "~");
            string[] arrDt = actualStr.Split('~');
            string tmpTimeInSec = arrDt[0].Trim() + arrDt[1].Trim() + arrDt[2].Trim() + Convert.ToString(Convert.ToInt64(Convert.ToInt64(arrDt[3].Trim()) * 60 * 60) + Convert.ToInt64(Convert.ToInt64(arrDt[4].Trim()) * 60) + Convert.ToInt64(arrDt[5].Trim()));
            return Convert.ToInt64(tmpTimeInSec);
        }

        public static string getEncriptedStr(string normalStr)
        {
            //MD5CryptoServiceProvider objMD5Hasher = new MD5CryptoServiceProvider();
            //byte[] hashedDataBytes;
            //UTF8Encoding objEncoder = new UTF8Encoding();
            //StringBuilder encriptedStr = new StringBuilder();

            //hashedDataBytes = objMD5Hasher.ComputeHash(objEncoder.GetBytes(normalStr));

            //for (int i = 0; i < hashedDataBytes.Length - 1; i++)
            //{
            //    encriptedStr.Append(hashedDataBytes[i].ToString());
            //}
            //return encriptedStr.ToString().Remove(30);
            string EncryptionKey = "";
            byte[] clearBytes = Encoding.Unicode.GetBytes(normalStr);
            using (Aes encryptor = Aes.Create())
            {
                Rfc2898DeriveBytes pdb = new Rfc2898DeriveBytes(EncryptionKey, new byte[] { 0x49, 0x76, 0x61, 0x6e, 0x20, 0x4d, 0x65, 0x64, 0x76, 0x65, 0x64, 0x65, 0x76 });
                encryptor.Key = pdb.GetBytes(32);
                encryptor.IV = pdb.GetBytes(16);
                using (MemoryStream ms = new MemoryStream())
                {
                    using (CryptoStream cs = new CryptoStream(ms, encryptor.CreateEncryptor(), CryptoStreamMode.Write))
                    {
                        cs.Write(clearBytes, 0, clearBytes.Length);
                        cs.Close();
                    }
                    normalStr = Convert.ToBase64String(ms.ToArray());
                }
            }
            return normalStr;
        }

        #endregion
    }
}