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
        public GenericReturn GetById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation
            if (id == 0)
            {
                _objRet.Message = "Error";
                _objRet.Errors.Add("ERR155");
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }
            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal_Rights objAcq_Deal_Rights = new Acq_Deal_Rights();

                    objAcq_Deal_Rights = objAcquisitionDealRepositories.GetById(id);

                    //objAcq_Deal_Rights.inserted_on = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.Rig))

                    //objAcq_Deal_Rights.inserted_on = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.Inserted_On.Value));
                    //objAcq_Deal_Rights.updated_on = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.Last_Updated_Time));
                    if(objAcq_Deal_Rights == null)
                    {
                        _objRet.Message = "Error";
                        _objRet.Errors.Add("ERR196");
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                    _objRet.Response = objAcq_Deal_Rights;
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
                _objRet = GlobalTool.SetError(_objRet, "ERR154");
            }

            #endregion

            objInput.Right_Start_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.Right_Start_Date));
            objInput.Right_End_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.Right_End_Date));
            objInput.ROFR_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.ROFR_Date));

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

            if (_objRet.IsSuccess)
            {
                var objDealRights = objAcquisitionDealRepositories.GetById(objInput.Acq_Deal_Rights_Code);

                if (objDealRights != null)
                {
                    objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                    objInput.Last_Updated_Time = DateTime.Now;
                }

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


                objAcquisitionDealRepositories.Update(objInput);
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


            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

            return _objRet;

        }

        

    }
}
