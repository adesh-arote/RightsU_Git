using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Security.Cryptography;
using System.Text;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class ForgetPasswordLinkController : Controller
    {
        // GET: ForgetPasswordLink
        private List<LoginEntity> lstLoginEntities
        {
            get
            {
                if (Session["lstLoginEntities"] == null)
                    Session["lstLoginEntities"] = new List<LoginEntity>();
                return (List<LoginEntity>)Session["lstLoginEntities"];
            }
            set
            {
                Session["lstLoginEntities"] = value;
            }
        }
        public LoginEntity objLoginEntity
        {
            get
            {
                if (Session["objLoginEntity"] == null)
                    Session["objLoginEntity"] = new LoginEntity();
                return (LoginEntity)Session["objLoginEntity"];
            }
            set { Session["objLoginEntity"] = value; }
        }
        private Users_Password_Detail_Service objUPD_Service
        {
            get
            {
                if (Session["objUPD_Service"] == null)
                    Session["objUPD_Service"] = new Users_Password_Detail_Service(objLoginEntity.ConnectionStringName);
                return (Users_Password_Detail_Service)Session["objUPD_Service"];
            }
            set
            {
                Session["objUPD_Service"] = value;
            }
        }

        public User_Service objUser_Service
        {
            get
            {
                if (Session["User_Service"] == null)
                    Session["User_Service"] = new User_Service(objLoginEntity.ConnectionStringName);
                return (User_Service)Session["User_Service"];
            }
            set { Session["User_Service"] = value; }
        }

        public MessageKey objMessageKey
        {
            get
            {
                if (Session["objMessageKey"] == null)
                    Session["objMessageKey"] = new MessageKey();
                return (MessageKey)Session["objMessageKey"];
            }
            set { Session["objMessageKey"] = value; }
        }

        public ActionResult Index()
        { 
            if (Request.QueryString["Linkid"] != null && Request.QueryString["Entype"] != null)
            {
                LoginEntity objLoginEntity = lstLoginEntities.Where(w => w.ShortName == Request.QueryString["Entype"].ToString()).FirstOrDefault();
                if (objLoginEntity == null)
                    objLoginEntity = new LoginEntity();

                User objUser = null;
                objUser = GetUserByGuid(Request.QueryString["Linkid"].ToString());
                Session["objMessageKey"] = null;

                int System_Language_Code = objUser != null ? Convert.ToInt32(objUser.System_Language_Code) : 1;
                LoadSystemMessage(Convert.ToInt32(System_Language_Code), GlobalParams.ModuleCodeForUsers);
                ViewBag.MesageKey = Session["objMessageKey"];

                if (objUser != null)
                {

                    DateTime currentTime = DateTime.Now;
                    DateTime dt = Convert.ToDateTime(objUser.Last_Updated_Time);
                    var dif = currentTime.Subtract(dt);
                    if (dif.Hours > 0)
                    {
                        return RedirectToAction("Index", "Login", new { alertMsg = ViewBag.MesageKey.FPLinkExpire });
                    }
                    else if(dif.Minutes > 30 )
                    {
                        return RedirectToAction("Index", "Login", new { alertMsg = ViewBag.MesageKey.FPLinkExpire });
                    }
                }
                else
                {
                 
                    return RedirectToAction("Index", "Login", new { alertMsg = ViewBag.MesageKey.FPLinkexpireOrAlrChange });
                }
            }
            else
            {
                return RedirectToAction("Index", "Login", new { alertMsg = "Invalid Url or link expired" });
            }
            return View();
        }

        public JsonResult SaveCHangesPass(string NewPassword, string ConfirmPassword,string Entypes,string Linkids)
        {
            Dictionary<string, object> dicobj = new Dictionary<string, object>();
           
            //string AlertMessage = "";

            LoginEntity objLoginEntity = lstLoginEntities.Where(w => w.ShortName == Entypes).FirstOrDefault();
            if (objLoginEntity == null)
                objLoginEntity = new LoginEntity();
            ViewBag.MesageKey = Session["objMessageKey"];
           
            Users_Password_Detail_Service objUPD_Service = new Users_Password_Detail_Service(objLoginEntity.ConnectionStringName);
            User objUser = null;
            objUser = GetUserByGuid(Linkids);
            if (objUser != null)
            {
                if (objUser.Password == getEncriptedStr(NewPassword.Trim()))
                {
                   
                    TempData["Focus"] = "NewPassword";
                    dicobj.Add("Status", "E");
                    dicobj.Add("msg", ViewBag.MesageKey.FPSamePassword);
                    return Json(dicobj);
                }
                else if (NewPassword.Trim().ToLower().Contains(objUser.Login_Name.ToLower())
                     || NewPassword.Trim().ToLower().Contains(objUser.First_Name.ToLower())
                     || (objUser.Last_Name != "" && NewPassword.ToLower().Trim().Contains(objUser.Last_Name.ToLower())))
                {
                   
                    TempData["Focus"] = "NewPassword";
                    dicobj.Add("Status", "E");
                    dicobj.Add("msg", ViewBag.MesageKey.FPContainFirstLastNm);
                    return Json(dicobj);

                }
                else
                {
                

                    int Lst5PwdsCnt = CheckLast5Pwds(objUser.Users_Code, NewPassword.Trim());
                    if (Lst5PwdsCnt > 0)
                    {
                       
                        TempData["Focus"] = "NewPassword";
                        //Session["FileName"] = "";
                        //Session["FileName"] = "ChangePassword";
                        dicobj.Add("Status", "E");
                        dicobj.Add("msg", ViewBag.MesageKey.FPHistory);
                        return Json(dicobj);
                    }
                    else
                    {
                        objUser.Password = getEncriptedStr(NewPassword.Trim());
                        objUser.Is_System_Password = "N";
                        objUser.Password_Fail_Count = 0;
                        objUser.Last_Updated_Time = DateTime.Now;
                        objUser.ChangePasswordLinkGUID = null;
                        objUser.EntityState = State.Modified;
                        objUser_Service.Save(objUser);
                        Users_Password_Detail ObjUPD = new Users_Password_Detail();
                        ObjUPD.Users_Code = objUser.Users_Code;
                        ObjUPD.Users_Passwords = getEncriptedStr(NewPassword.Trim());
                        ObjUPD.Password_Change_Date = DateTime.Now;

                        ObjUPD.EntityState = State.Added;
                        dynamic resultSet;
                        bool isValid = objUPD_Service.Save(ObjUPD, out resultSet);
                        Session.Abandon();
                        dicobj.Add("msg", ViewBag.MesageKey.FPLinkexpireSuccess);
                        dicobj.Add("Status", "S");
                        return Json(dicobj);

                    }
                }
            }
            else
            {
                dicobj.Add("Status", "E");
                dicobj.Add("msg", ViewBag.MesageKey.FPLinkexpireOrAlrChange);
                
                return Json(dicobj);
            }
        }
        private User GetUserByGuid(string guid)
        {
            User objUser = objUser_Service.SearchFor(x => x.ChangePasswordLinkGUID.ToUpper() == guid.ToUpper()).FirstOrDefault();

            if (objUser != null)
            {
                return objUser;
            }
            else
            {
                return null;
            }
        }
        private int CheckLast5Pwds(int UserCode = 0, string NewPassWord = "")
        {
            
            string EncryptedPassword = getEncriptedStr(NewPassWord);
            List<Users_Password_Detail> Last5PwdsList = new Users_Password_Detail_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Users_Code == UserCode).OrderByDescending(x => x.Password_Change_Date).Take(5).ToList();
            int Lst5PwdsCnt = 0;

            if (Last5PwdsList.Count() > 0)
            {
                Lst5PwdsCnt = Last5PwdsList.Where(x => x.Users_Passwords == EncryptedPassword).Count();
            }

            return Lst5PwdsCnt;
        }

        private string getEncriptedStr(string normalStr)
        {
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
        public JsonResult GetPWDPolicyDetailList(string Entypes, string Linkids)
        {
            LoginEntity objLoginEntity = lstLoginEntities.Where(w => w.ShortName == Entypes.ToString()).FirstOrDefault();
            if (objLoginEntity == null)
                objLoginEntity = new LoginEntity();

            var PWDPolicyDetailList = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Parameter_Name.Contains("PWD_Policy_")).ToList();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("PWDPolicyDetailList", new SelectList(PWDPolicyDetailList, "Parameter_Value", "Parameter_Name"));
            return Json(obj);
        }
        //public JsonResult GetPWDHistoryCount(string data)
        //{
        //    User objUser = objUser = GetUserByGuid(Session["Entype"].ToString()); ;
        //    int Lst5PwdsCnt = CheckLast5Pwds(objUser.Users_Code, data.Trim());
        //    if (Lst5PwdsCnt > 0)
        //    {
        //        return Json(new { PWDHistoryCount = Lst5PwdsCnt, PWDHistoryMsg = "Please enter some other password, it matches your old password history" });
        //    }
        //    else
        //    {
        //        return Json(new { PWDHistoryCount = 0, PWDHistoryMsg = "NotFound" });
        //    }
        //}
        public void LoadSystemMessage(int systemLanguageCode, int moduleCode)
        { 
            if (systemLanguageCode > 0)
            {
                List<System_Language_Message> lstSystemMessage = new System_Language_Message_Service(objLoginEntity.ConnectionStringName).SearchFor(x =>
                x.System_Language_Code == systemLanguageCode && (x.System_Module_Message.Module_Code == moduleCode ||
                (x.System_Module_Message.Module_Code ?? 0) == 0
                )).ToList();
                objMessageKey.LayoutDirection = lstSystemMessage.FirstOrDefault().System_Language.Layout_Direction;
                Type type = objMessageKey.GetType();
                PropertyInfo[] prop = type.GetProperties();
                foreach (var p in prop)
                {
                    string a = p.Name;
                    string v = lstSystemMessage.Where(w => w.System_Module_Message.System_Message.Message_Key.Trim() == p.Name.Trim()).Select(s => s.Message_Desc).FirstOrDefault();
                    if (!string.IsNullOrEmpty(v))
                    {
                        p.SetValue(objMessageKey, v.Replace("\r\n", " "));
                    }
                }
            }
        }
    }
}