using RightsU.BMS.BLL.Miscellaneous;
using RightsU.BMS.DAL;
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
    public class DealServices
    {
        private readonly DealRepositories objDealRepositories = new DealRepositories();
        private readonly Acq_Deal_LicensorRepositories objAcq_Deal_LicensorRepositories = new Acq_Deal_LicensorRepositories();
        private readonly Acq_Deal_MovieRepositories objAcq_Deal_MovieRepositories = new Acq_Deal_MovieRepositories();

        public GenericReturn GetById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR155");
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal objDealGeneral = new Acq_Deal();

                    objDealGeneral = objDealRepositories.Get(id);

                    if (objDealGeneral != null)
                    {
                        objDealGeneral.agreement_date = Convert.ToString(GlobalTool.DateToLinux(objDealGeneral.Agreement_Date.Value));
                        //objDealGeneral.inserted_on = Convert.ToString(GlobalTool.DateToLinux(objDealGeneral.Inserted_On.Value));
                        //objDealGeneral.updated_on = Convert.ToString(GlobalTool.DateToLinux(objDealGeneral.Last_Updated_Time.Value));
                        //objDealGeneral.action_by = objDealGeneral.Inserted_By != null || objDealGeneral.Inserted_By.Value > 0 ? objDealGeneral.Inserted_By : objDealGeneral.Last_Action_By;
                    }
                    else
                    {
                        _objRet = GlobalTool.SetError(_objRet,"ERR183");
                    }
                    _objRet.Response = objDealGeneral;
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

        public GenericReturn Post(Acq_Deal objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            
            #region Input Validation

            if (objInput == null)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR154");
            }

            if (string.IsNullOrWhiteSpace(objInput.agreement_date))
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR156");
            }
            else
            {
                try
                {
                    objInput.Agreement_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.agreement_date));
                }
                catch (Exception ex)
                {
                    _objRet = GlobalTool.SetError(_objRet,"ERR157");
                }
            }

            if (string.IsNullOrWhiteSpace(objInput.Deal_Desc))
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR158");
            }

            if (objInput.Deal_Tag_Code == null || objInput.Deal_Tag_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR159");
            }

            if (string.IsNullOrWhiteSpace(objInput.Is_Master_Deal))
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR160");
            }
            //else if (objInput.Is_Master_Deal.ToUpper() != "Y" && objInput.Is_Master_Deal.ToUpper() != "N")
            //{
            //    _objRet.Message = "Input Paramater 'deal_for' is invalid";
            //    _objRet.IsSuccess = false;
            //    _objRet.StatusCode = HttpStatusCode.BadRequest;
            //    return _objRet;
            //}

            if (objInput.Role_Code == null || objInput.Role_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR161");
            }

            if (objInput.Deal_Type_Code == null || objInput.Deal_Type_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR162");
            }

            if (objInput.Entity_Code == null || objInput.Entity_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR163");
            }

            if (objInput.Vendor_Code == null || objInput.Vendor_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR164");
            }

            //if (objInput.Is_Master_Deal.ToUpper() == "N")
            //{
            //    if (objInput.Parent_Deal_Code == null || objInput.Parent_Deal_Code <= 0)
            //    {
            //        _objRet.Message = "Input Paramater 'master_deal_id' is mandatory";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            if (objInput.Is_Master_Deal.ToUpper() == "N")
            {
                if (objInput.Master_Deal_Movie_Code_ToLink == null || objInput.Master_Deal_Movie_Code_ToLink <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet,"ERR165");
                }
            }

            if (string.IsNullOrWhiteSpace(objInput.Year_Type))
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR166");
            }

            if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR167");
            }

            //if (objInput.Exchange_Rate == null || objInput.Exchange_Rate <= 0)
            //{
            //    _objRet.Message = "Input Paramater 'exchange_rate' is mandatory";
            //    _objRet.IsSuccess = false;
            //    _objRet.StatusCode = HttpStatusCode.BadRequest;
            //    return _objRet;
            //}

            if (objInput.Business_Unit_Code == null || objInput.Business_Unit_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR168");
            }

            if (objInput.Category_Code == null || objInput.Category_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR169");
            }

            //if (string.IsNullOrWhiteSpace(objInput.Deal_Workflow_Status))
            //{
            //    _objRet.Message = "Input Paramater 'workflow_status' is mandatory";
            //    _objRet.IsSuccess = false;
            //    _objRet.StatusCode = HttpStatusCode.BadRequest;
            //    return _objRet;
            //}

            if (objInput.licensors.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR170");
            }
            else
            {
                for (int i = 0; i < objInput.licensors.ToList().Count(); i++)
                {
                    if (objInput.licensors.ToList()[i].Vendor_Code == null || objInput.licensors.ToList()[i].Vendor_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet,"ERR171");
                    }
                }
            }

            if (objInput.titles.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR172");
            }
            else
            {
                for (int i = 0; i < objInput.titles.ToList().Count(); i++)
                {
                    if (objInput.titles.ToList()[i].Title_Code == null || objInput.titles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet,"ERR173");
                    }

                    if (objInput.titles.ToList()[i].Episode_Starts_From == null || objInput.titles.ToList()[i].Episode_Starts_From <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet,"ERR174");
                    }

                    if (objInput.titles.ToList()[i].Episode_End_To == null || objInput.titles.ToList()[i].Episode_End_To <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet,"ERR175");
                    }
                }
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                objInput.Agreement_No = string.Empty;
                objInput.Version = "0001";
                objInput.Inserted_On = DateTime.Now;
                objInput.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Last_Updated_Time = DateTime.Now;
                objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);


                List<Acq_Deal_Licensor> lstLicensors = new List<Acq_Deal_Licensor>();
                foreach (var item in objInput.licensors)
                {
                    Acq_Deal_Licensor objLicensor = new Acq_Deal_Licensor();

                    objLicensor.Acq_Deal_Code = item.Acq_Deal_Code;
                    objLicensor.Vendor_Code = item.Vendor_Code;
                    lstLicensors.Add(objLicensor);
                }
                objInput.licensors = lstLicensors;

                List<Acq_Deal_Movie> lstDealTitles = new List<Acq_Deal_Movie>();
                foreach (var item in objInput.titles)
                {
                    Acq_Deal_Movie objDealTitle = new Acq_Deal_Movie();
                    objDealTitle.Acq_Deal_Code = item.Acq_Deal_Code;
                    objDealTitle.Title_Code = item.Title_Code;
                    objDealTitle.Episode_Starts_From = item.Episode_Starts_From;
                    objDealTitle.Episode_End_To = item.Episode_End_To;
                    objDealTitle.Notes = item.Notes;
                    objDealTitle.Title_Type = item.Title_Type;
                    objDealTitle.Due_Diligence = item.Due_Diligence;
                    objDealTitle.Inserted_On = objInput.Inserted_On;
                    objDealTitle.Inserted_By = objInput.Inserted_By;
                    objDealTitle.Last_UpDated_Time = objInput.Last_Updated_Time;
                    objDealTitle.Last_Action_By = objInput.Last_Action_By;
                    lstDealTitles.Add(objDealTitle);
                }
                objInput.titles = lstDealTitles;

                objDealRepositories.Add(objInput);

                _objRet.id = objInput.Acq_Deal_Code;
            }

            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

            return _objRet;
        }

        public GenericReturn Put(Acq_Deal objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput == null)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR154");
            }

            if (objInput.Acq_Deal_Code == null || objInput.Acq_Deal_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR178");
            }

            if (string.IsNullOrWhiteSpace(objInput.agreement_date))
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR156");
            }
            else
            {
                try
                {
                    objInput.Agreement_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.agreement_date));
                }
                catch (Exception ex)
                {
                    _objRet = GlobalTool.SetError(_objRet,"ERR157");
                }
            }

            if (string.IsNullOrWhiteSpace(objInput.Deal_Desc))
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR158");
            }

            if (objInput.Deal_Tag_Code == null || objInput.Deal_Tag_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR159");
            }

            if (string.IsNullOrWhiteSpace(objInput.Is_Master_Deal))
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR160");
            }

            if (objInput.Role_Code == null || objInput.Role_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR161");
            }

            if (objInput.Deal_Type_Code == null || objInput.Deal_Type_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR162");
            }

            if (objInput.Entity_Code == null || objInput.Entity_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR163");
            }

            if (objInput.Vendor_Code == null || objInput.Vendor_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR164");
            }

            if (objInput.Is_Master_Deal != null && objInput.Is_Master_Deal.ToUpper() == "N")
            {
                if (objInput.Master_Deal_Movie_Code_ToLink == null || objInput.Master_Deal_Movie_Code_ToLink <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet,"ERR165");
                }
            }

            if (string.IsNullOrWhiteSpace(objInput.Year_Type))
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR166");
            }

            if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR167");
            }

            if (objInput.Business_Unit_Code == null || objInput.Business_Unit_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR168");
            }

            if (objInput.Category_Code == null || objInput.Category_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR169");
            }

            if (objInput.licensors.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR170");
            }
            else
            {
                for (int i = 0; i < objInput.licensors.ToList().Count(); i++)
                {
                    if (objInput.licensors.ToList()[i].Vendor_Code == null || objInput.licensors.ToList()[i].Vendor_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet,"ERR171");
                    }
                }
            }

            if (objInput.titles.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet,"ERR172");
            }
            else
            {
                for (int i = 0; i < objInput.titles.ToList().Count(); i++)
                {
                    if (objInput.titles.ToList()[i].Title_Code == null || objInput.titles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet,"ERR173");
                    }

                    if (objInput.titles.ToList()[i].Episode_Starts_From == null || objInput.titles.ToList()[i].Episode_Starts_From <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet,"ERR174");
                    }

                    if (objInput.titles.ToList()[i].Episode_End_To == null || objInput.titles.ToList()[i].Episode_End_To <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet,"ERR175");
                    }
                }
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                var objDeal = objDealRepositories.Get(objInput.Acq_Deal_Code.Value);

                if (objDeal != null)
                {
                    objInput.Agreement_No = objDeal.Agreement_No;
                    objInput.Version = objDeal.Version;

                    objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                    objInput.Last_Updated_Time = DateTime.Now;

                    #region Licensor

                    objDeal.licensors.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.licensors)
                    {
                        Acq_Deal_Licensor objT = (Acq_Deal_Licensor)objDeal.licensors.Where(t => t.Vendor_Code == item.Vendor_Code).Select(i => i).FirstOrDefault();

                        if (objT == null)
                            objT = new Acq_Deal_Licensor();
                        if (objT.Acq_Deal_Licensor_Code > 0)
                            objT.EntityState = State.Unchanged;
                        else
                        {
                            objT.EntityState = State.Added;
                            objT.Acq_Deal_Code = objInput.Acq_Deal_Code;
                            objT.Vendor_Code = item.Vendor_Code;
                            objDeal.licensors.Add(objT);
                        }
                    }

                    foreach (var item in objDeal.licensors.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objAcq_Deal_LicensorRepositories.Delete(item);
                    }

                    var objCountry = objDeal.licensors.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objCountry.ForEach(i => objDeal.licensors.Remove(i));

                    objInput.licensors = objDeal.licensors;

                    #endregion

                    #region Acq_Deal_Movie

                    objDeal.titles.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.titles)
                    {
                        Acq_Deal_Movie objT = (Acq_Deal_Movie)objDeal.titles.Where(t => t.Title_Code == item.Title_Code).Select(i => i).FirstOrDefault();

                        if (objT == null)
                            objT = new Acq_Deal_Movie();
                        if (objT.Acq_Deal_Movie_Code > 0)
                        {
                            objT.EntityState = State.Unchanged;
                            objT.Acq_Deal_Code = objInput.Acq_Deal_Code;
                            objT.Title_Code = item.Title_Code;
                            objT.Episode_Starts_From = item.Episode_Starts_From;
                            objT.Episode_End_To = item.Episode_End_To;
                            objT.Notes = item.Notes;
                            objT.Title_Type = item.Title_Type;
                            objT.Due_Diligence = item.Due_Diligence;
                            objT.Last_UpDated_Time = objInput.Last_Updated_Time;
                            objT.Last_Action_By = objInput.Last_Action_By;
                        }
                        else
                        {
                            objT.EntityState = State.Added;
                            objT.Acq_Deal_Code = objInput.Acq_Deal_Code;
                            objT.Title_Code = item.Title_Code;
                            objT.Episode_Starts_From = item.Episode_Starts_From;
                            objT.Episode_End_To = item.Episode_End_To;
                            objT.Notes = item.Notes;
                            objT.Title_Type = item.Title_Type;
                            objT.Due_Diligence = item.Due_Diligence;
                            objT.Inserted_On = objInput.Last_Updated_Time;
                            objT.Inserted_By = objInput.Last_Action_By;
                            objT.Last_UpDated_Time = objInput.Last_Updated_Time;
                            objT.Last_Action_By = objInput.Last_Action_By;
                            objDeal.titles.Add(objT);
                        }
                    }

                    foreach (var item in objDeal.titles.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objAcq_Deal_MovieRepositories.Delete(item);
                    }

                    var objDealTitle = objDeal.titles.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objDealTitle.ForEach(i => objDeal.titles.Remove(i));

                    objInput.titles = objDeal.titles;

                    #endregion

                    objDealRepositories.Update(objInput);
                }
                else
                {
                    _objRet = GlobalTool.SetError(_objRet,"ERR183");
                }
                _objRet.id = objInput.Acq_Deal_Code;
            }

            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

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
                _objRet = GlobalTool.SetError(_objRet,"ERR155");
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal objDealGeneral = new Acq_Deal();

                    objDealGeneral = objDealRepositories.Get(id);

                    if (objDealGeneral != null)
                    {
                        objDealRepositories.Delete(objDealGeneral);

                        _objRet.id = objDealGeneral.Acq_Deal_Code;
                    }
                    else
                    {
                        _objRet = GlobalTool.SetError(_objRet,"ERR183");
                    }
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
    }
}
