using RightsU.BMS.BLL.Miscellaneous;
using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace RightsU.BMS.BLL.Services
{
    public class AcquisitionDealServices
    {
        private readonly AcquisitionDealRepositories objAcquisitionDealRepositories = new AcquisitionDealRepositories();
        private readonly Acq_Deal_Rights_PlatformRepositories objAcq_Deal_Rights_PlatformRepositories = new Acq_Deal_Rights_PlatformRepositories();
        private readonly Acq_Deal_Rights_TerritoryRepositories objAcq_Deal_Rights_TerritoryRepositories = new Acq_Deal_Rights_TerritoryRepositories();
        private readonly Acq_Deal_Rights_SubtitlingRepositories objAcq_Deal_Rights_SubtitlingRepositories = new Acq_Deal_Rights_SubtitlingRepositories();
        private readonly Acq_Deal_Rights_DubbingRepositories objAcq_Deal_Rights_DubbingRepositories = new Acq_Deal_Rights_DubbingRepositories();
        private readonly TitleRepositories objTitleRepositories = new TitleRepositories();
        private readonly DealRepositories objDealRepositories = new DealRepositories();
        public GenericReturn GetById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation
            if (id == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR155");
            }
            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal_Rights objAcq_Deal_Rights = new Acq_Deal_Rights();

                    objAcq_Deal_Rights = objAcquisitionDealRepositories.GetById(id);

                    if (objAcq_Deal_Rights != null)
                    {

                        objAcq_Deal_Rights.right_start_date = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.Right_Start_Date ?? DateTime.Now));
                        objAcq_Deal_Rights.right_end_date = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.Right_End_Date ?? DateTime.Now));
                        objAcq_Deal_Rights.rofr_date = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.ROFR_Date ?? DateTime.Now));

                    }
                    else
                    {


                        _objRet = GlobalTool.SetError(_objRet, "ERR252");
                    }
                    _objRet.Response = objAcq_Deal_Rights;
                }

                if (!_objRet.IsSuccess)
                {
                    _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return _objRet;
        }

        public GenericReturn Post(Acq_Deal_Rights objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput == null)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR262");
            }

            if(objInput.Acq_Deal_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR263");
            }

            if (String.IsNullOrEmpty(objInput.Is_Exclusive))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR264");
            }

            if (String.IsNullOrEmpty(objInput.Is_Exclusive))
            {
                if (objInput.Subtitling.Count() <= 0 && objInput.Dubbing.Count <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR265");
                }

            }

            if (String.IsNullOrEmpty(objInput.Is_Sub_License))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR266");
            }

            if (!String.IsNullOrEmpty(objInput.Is_Sub_License))
            {
                if (objInput.Sub_License_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR267");
                }
            }

            if (String.IsNullOrEmpty(objInput.Right_Type))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR268");
            }

            if (objInput.Titles.Count <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR269");
            }
            else
            {
                for (int i = 0; i < objInput.Titles.ToList().Count(); i++)
                {
                    if (objInput.Titles.ToList()[i].Title_Code == null || objInput.Titles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR173");
                    }
                }
            }

            if (objInput.Region.Count <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR270");
            }
            else
            {
                for (int i = 0; i < objInput.Region.ToList().Count(); i++)
                {
                    if ((objInput.Region.ToList()[i].Country_Code == null || objInput.Region.ToList()[i].Country_Code <= 0)
                        && (objInput.Region.ToList()[i].Territory_Code == null || objInput.Region.ToList()[i].Territory_Code <= 0))
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR272");
                    }
                }
            }

            if (objInput.Platform.Count <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR271");
            }
            else
            {
                for (int i = 0; i < objInput.Platform.ToList().Count(); i++)
                {
                    if (objInput.Platform.ToList()[i].Platform_Code == null || objInput.Platform.ToList()[i].Platform_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR274");
                    }
                }
            }

            #endregion

            DateTime stDate = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.right_start_date));
            DateTime enDate = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.right_end_date));
            string strCalculatTerm = "Select [dbo].[UFN_Calculate_Term]('"+ stDate.ToString("dd/MMMM/yyyy") + "', '"+ enDate.ToString("dd/MMMM/yyyy") + "') AS Term";

            objInput.Term = Convert.ToString(objAcquisitionDealRepositories.GetDataWithSQLStmt(strCalculatTerm).FirstOrDefault().Term);
            objInput.Right_Start_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.right_start_date));
            objInput.Right_End_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.right_end_date));
            objInput.ROFR_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.rofr_date));
            objInput.Actual_Right_Start_Date = objInput.Right_Start_Date;
            objInput.Actual_Right_End_Date = objInput.Right_End_Date;
            objInput.Effective_Start_Date = objInput.Right_Start_Date;
            objInput.Inserted_On = DateTime.Now;
            objInput.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
            objInput.Last_Updated_Time = DateTime.Now;
            objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);

            objInput.Right_Status = "P";


            List<Acq_Deal_Rights_Title> lstAcq_Deal_Rights_Title = new List<Acq_Deal_Rights_Title>();
            foreach (var item in objInput.Titles)
            {
                Acq_Deal_Rights_Title objAcqDealRightsTitle = new Acq_Deal_Rights_Title();

                objAcqDealRightsTitle.Title_Code = item.Title_Code;
                objAcqDealRightsTitle.Episode_From = item.Episode_From;
                objAcqDealRightsTitle.Episode_To = item.Episode_To;
                lstAcq_Deal_Rights_Title.Add(objAcqDealRightsTitle);
            }
            objInput.Titles = lstAcq_Deal_Rights_Title;

            List<Acq_Deal_Rights_Platform> lstAcq_Deal_Rights_Platform = new List<Acq_Deal_Rights_Platform>();
            foreach (var item in objInput.Platform)
            {
                Acq_Deal_Rights_Platform objAcq_Deal_Rights_Platform = new Acq_Deal_Rights_Platform();

                objAcq_Deal_Rights_Platform.Platform_Code = item.Platform_Code;
                lstAcq_Deal_Rights_Platform.Add(objAcq_Deal_Rights_Platform);
            }
            objInput.Platform = lstAcq_Deal_Rights_Platform;

            List<Acq_Deal_Rights_Territory> lstAcq_Deal_Rights_Territory = new List<Acq_Deal_Rights_Territory>();
            foreach (var item in objInput.Region)
            {
                Acq_Deal_Rights_Territory objAcq_Deal_Rights_Territory = new Acq_Deal_Rights_Territory();

                objAcq_Deal_Rights_Territory.Territory_Type = item.Territory_Type;
                objAcq_Deal_Rights_Territory.Territory_Code = item.Territory_Code;
                objAcq_Deal_Rights_Territory.Country_Code = item.Country_Code;
                lstAcq_Deal_Rights_Territory.Add(objAcq_Deal_Rights_Territory);
            }
            objInput.Region = lstAcq_Deal_Rights_Territory;

            List<Acq_Deal_Rights_Subtitling> lstAcq_Deal_Rights_Subtitling = new List<Acq_Deal_Rights_Subtitling>();
            foreach (var item in objInput.Subtitling)
            {
                Acq_Deal_Rights_Subtitling objAcq_Deal_Rights_Subtitling = new Acq_Deal_Rights_Subtitling();

                objAcq_Deal_Rights_Subtitling.Language_Type = item.Language_Type;
                objAcq_Deal_Rights_Subtitling.Language_Code = item.Language_Code;
                objAcq_Deal_Rights_Subtitling.Language_Group_Code = item.Language_Group_Code;
                lstAcq_Deal_Rights_Subtitling.Add(objAcq_Deal_Rights_Subtitling);
            }
            objInput.Subtitling = lstAcq_Deal_Rights_Subtitling;

            List<Acq_Deal_Rights_Dubbing> lstAcq_Deal_Rights_Dubbing = new List<Acq_Deal_Rights_Dubbing>();
            foreach (var item in objInput.Dubbing)
            {
                Acq_Deal_Rights_Dubbing objAcq_Deal_Rights_Dubbing = new Acq_Deal_Rights_Dubbing();

                objAcq_Deal_Rights_Dubbing.Language_Type = item.Language_Type;
                objAcq_Deal_Rights_Dubbing.Language_Code = item.Language_Code;
                objAcq_Deal_Rights_Dubbing.Language_Group_Code = item.Language_Group_Code;
                lstAcq_Deal_Rights_Dubbing.Add(objAcq_Deal_Rights_Dubbing);
            }
            objInput.Dubbing = lstAcq_Deal_Rights_Dubbing;


            objAcquisitionDealRepositories.Add(objInput);

            _objRet.Response = new { id = objInput.Acq_Deal_Code };

            return _objRet;
        }

        public GenericReturn Delete(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal_Rights objDealRights = new Acq_Deal_Rights();

                    objDealRights = objAcquisitionDealRepositories.GetById(id);

                    objAcquisitionDealRepositories.Delete(objDealRights);

                    _objRet.Response = new { id = objDealRights.Acq_Deal_Rights_Code };
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn Put(Acq_Deal_Rights objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validations

            if (objInput == null)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR262");
            }

            if (objInput.Acq_Deal_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR263");
            }

            if (String.IsNullOrEmpty(objInput.Is_Exclusive))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR264");
            }

            if (String.IsNullOrEmpty(objInput.Is_Exclusive))
            {
                if(objInput.Subtitling.Count() <= 0 && objInput.Dubbing.Count <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR265");
                }
                
            }

            if (String.IsNullOrEmpty(objInput.Is_Sub_License))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR266");
            }

            if (!String.IsNullOrEmpty(objInput.Is_Sub_License))
            {
                if(objInput.Sub_License_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR267");
                }
            }

            if (String.IsNullOrEmpty(objInput.Right_Type))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR268");
            }

            if (objInput.Titles.Count <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR269");
            }
            else
            {
                for (int i = 0; i < objInput.Titles.ToList().Count(); i++)
                {
                    if (objInput.Titles.ToList()[i].Title_Code == null || objInput.Titles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR173");
                    }
                }
            }

            if (objInput.Region.Count <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR270");
            }
            else
            {
                for (int i = 0; i < objInput.Region.ToList().Count(); i++)
                {
                    if ((objInput.Region.ToList()[i].Country_Code == null || objInput.Region.ToList()[i].Country_Code <= 0) 
                        && (objInput.Region.ToList()[i].Territory_Code == null || objInput.Region.ToList()[i].Territory_Code <= 0))
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR272");
                    }
                }
            }

            if (objInput.Platform.Count <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR271");
            }
            else
            {
                for (int i = 0; i < objInput.Platform.ToList().Count(); i++)
                {
                    if (objInput.Platform.ToList()[i].Platform_Code == null || objInput.Platform.ToList()[i].Platform_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR274");
                    }
                }
            }

            #endregion


            if (_objRet.IsSuccess)
            {
                var objDealRights = objAcquisitionDealRepositories.GetById(objInput.Acq_Deal_Rights_Code);

                if (objDealRights != null)
                {
                    objInput.Inserted_On = objDealRights.Inserted_On;
                    objInput.Inserted_By = objDealRights.Inserted_By;
                    objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                    objInput.Last_Updated_Time = DateTime.Now;

                    //-----Pending Columns-----------
                    objInput.Term = objDealRights.Term;
                    objInput.Effective_Start_Date = objDealRights.Effective_Start_Date;
                    objInput.Actual_Right_Start_Date = objDealRights.Actual_Right_Start_Date;
                    objInput.Actual_Right_End_Date = objDealRights.Actual_Right_End_Date;
                    objInput.Is_ROFR = objDealRights.Is_ROFR;
                    objInput.Is_Verified = objDealRights.Is_Verified;
                    objInput.Original_Right_Type = objDealRights.Original_Right_Type;
                    objInput.Right_Status = objInput.Right_Status;
                    objInput.Promoter_Flag = objInput.Promoter_Flag;
                    objInput.Is_Under_Production = objInput.Is_Under_Production;
                    objInput.Buyback_Syn_Rights_Code = objInput.Buyback_Syn_Rights_Code;
                    //--------- Pending Columns





                    #region Titles

                    objDealRights.Titles.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.Titles)
                    {
                        Acq_Deal_Rights_Title objT = (Acq_Deal_Rights_Title)objDealRights.Titles.Where(t => t.Title_Code == item.Title_Code).Select(i => i).FirstOrDefault();

                        if (objT == null)
                            objT = new Acq_Deal_Rights_Title();
                        if (objT.Acq_Deal_Rights_Title_Code > 0)
                            objT.EntityState = State.Unchanged;
                        else
                        {
                            objT.EntityState = State.Added;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Title_Code = item.Title_Code;
                            objDealRights.Titles.Add(objT);
                        }
                    }



                    #endregion

                    #region Acq_Deal_Rights_Platform

                    objDealRights.Platform.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.Platform)
                    {
                        Acq_Deal_Rights_Platform objT = (Acq_Deal_Rights_Platform)objDealRights.Platform.Where(t => t.Platform_Code == item.Platform_Code).Select(i => i).FirstOrDefault();

                        if (objT == null)
                            objT = new Acq_Deal_Rights_Platform();
                        if (objT.Acq_Deal_Rights_Platform_Code > 0)
                        {
                            objT.EntityState = State.Unchanged;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Platform_Code = item.Platform_Code;
                        }
                        else
                        {
                            objT.EntityState = State.Added;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Platform_Code = item.Platform_Code;
                            objDealRights.Platform.Add(objT);
                        }
                    }

                    foreach (var item in objDealRights.Platform.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objAcq_Deal_Rights_PlatformRepositories.Delete(item);
                    }

                    var objDealRightsPlatform = objDealRights.Platform.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objDealRightsPlatform.ForEach(i => objDealRights.Platform.Remove(i));

                    objInput.Platform = objDealRights.Platform;

                    #endregion

                    #region Acq_Deal_Rights_Territory

                    objDealRights.Region.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.Region)
                    {
                        Acq_Deal_Rights_Territory objT = (Acq_Deal_Rights_Territory)objDealRights.Region.Where(t => t.Territory_Code == item.Territory_Code).Select(i => i).FirstOrDefault();

                        if (objT == null)
                            objT = new Acq_Deal_Rights_Territory();
                        if (objT.Acq_Deal_Rights_Territory_Code > 0)
                        {
                            objT.EntityState = State.Unchanged;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Territory_Type = item.Territory_Type;
                            objT.Country_Code = item.Country_Code;
                            objT.Territory_Code = item.Territory_Code;
                        }
                        else
                        {
                            objT.EntityState = State.Added;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Territory_Type = item.Territory_Type;
                            objT.Country_Code = item.Country_Code;
                            objT.Territory_Code = item.Territory_Code;
                            objDealRights.Region.Add(objT);
                        }
                    }

                    foreach (var item in objDealRights.Region.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objAcq_Deal_Rights_TerritoryRepositories.Delete(item);
                    }

                    var objDealRightsTerritory = objDealRights.Region.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objDealRightsTerritory.ForEach(i => objDealRights.Region.Remove(i));

                    objInput.Region = objDealRights.Region;

                    #endregion

                    #region Acq_Deal_Rights_Subtitling

                    objDealRights.Subtitling.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.Subtitling)
                    {
                        Acq_Deal_Rights_Subtitling objT = (Acq_Deal_Rights_Subtitling)objDealRights.Subtitling.Where(t => t.Language_Code == item.Language_Code).Select(i => i).FirstOrDefault();

                        if (objT == null)
                            objT = new Acq_Deal_Rights_Subtitling();
                        if (objT.Acq_Deal_Rights_Subtitling_Code > 0)
                        {
                            objT.EntityState = State.Unchanged;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Language_Type = item.Language_Type;
                            objT.Language_Code = item.Language_Code;
                            objT.Language_Group_Code = item.Language_Group_Code;
                        }
                        else
                        {
                            objT.EntityState = State.Added;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Language_Type = item.Language_Type;
                            objT.Language_Code = item.Language_Code;
                            objT.Language_Group_Code = item.Language_Group_Code;
                        }
                    }

                    foreach (var item in objDealRights.Subtitling.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objAcq_Deal_Rights_SubtitlingRepositories.Delete(item);
                    }

                    var objDealRightsSubtitling = objDealRights.Subtitling.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objDealRightsSubtitling.ForEach(i => objDealRights.Subtitling.Remove(i));

                    objInput.Subtitling = objDealRights.Subtitling;

                    #endregion

                    #region Acq_Deal_Rights_Dubbing

                    objDealRights.Dubbing.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.Dubbing)
                    {
                        Acq_Deal_Rights_Dubbing objT = (Acq_Deal_Rights_Dubbing)objDealRights.Dubbing.Where(t => t.Language_Code == item.Language_Code).Select(i => i).FirstOrDefault();

                        if (objT == null)
                            objT = new Acq_Deal_Rights_Dubbing();
                        if (objT.Acq_Deal_Rights_Dubbing_Code > 0)
                        {
                            objT.EntityState = State.Unchanged;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Language_Type = item.Language_Type;
                            objT.Language_Code = item.Language_Code;
                            objT.Language_Group_Code = item.Language_Group_Code;
                        }
                        else
                        {
                            objT.EntityState = State.Added;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Acq_Deal_Rights_Code = objInput.Acq_Deal_Rights_Code;
                            objT.Language_Type = item.Language_Type;
                            objT.Language_Code = item.Language_Code;
                            objT.Language_Group_Code = item.Language_Group_Code;
                        }
                    }

                    foreach (var item in objDealRights.Dubbing.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objAcq_Deal_Rights_DubbingRepositories.Delete(item);
                    }

                    var objDealRightsDubbing = objDealRights.Dubbing.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objDealRightsDubbing.ForEach(i => objDealRights.Dubbing.Remove(i));

                    objInput.Dubbing = objDealRights.Dubbing;

                    #endregion
                }

                objAcquisitionDealRepositories.Update(objInput);
            }


            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

            return _objRet;

        }

        

    }
}
