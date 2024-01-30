using RightsU.BMS.BLL.Miscellaneous;
using RightsU.BMS.DAL;
using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using RightsU.BMS.Entities.ReturnClasses;
using System;
using System.Collections.Generic;
using System.Configuration;
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
        private readonly AcquisitionDealRepositories objDealRightsRepositories = new AcquisitionDealRepositories();

        public GenericReturn GetDealList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validations

            if (!string.IsNullOrWhiteSpace(order))
            {
                if (order.ToUpper() != "ASC")
                {
                    if (order.ToUpper() != "DESC")
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR184");
                    }
                }
            }
            else
            {
                order = ConfigurationManager.AppSettings["defaultOrder"];
            }

            if (page == 0)
            {
                page = Convert.ToInt32(ConfigurationManager.AppSettings["defaultPage"]);
            }

            if (size > 0)
            {
                var maxSize = Convert.ToInt32(ConfigurationManager.AppSettings["maxSize"]);
                if (size > maxSize)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR185");
                }
            }
            else
            {
                size = Convert.ToInt32(ConfigurationManager.AppSettings["defaultSize"]);
            }

            if (!string.IsNullOrWhiteSpace(sort.ToString()))
            {
                if (sort.ToLower() == "CreatedDate".ToLower())
                {
                    sort = "Inserted_On";
                }
                else if (sort.ToLower() == "UpdatedDate".ToLower())
                {
                    sort = "Last_Updated_Time";
                }
                //else if (sort.ToLower() == "TitleName".ToLower())
                //{
                //    sort = "Title_Name";
                //}
                else
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR186");
                }
            }
            else
            {
                sort = ConfigurationManager.AppSettings["defaultSort"];
            }

            try
            {
                if (!string.IsNullOrWhiteSpace(Date_GT))
                {
                    try
                    {
                        Date_GT = GlobalTool.LinuxToDate(Convert.ToDouble(Date_GT)).ToString("yyyy-MM-dd HH:mm:ss");
                        //Date_GT = DateTime.Parse(Date_GT).ToString("yyyy-MM-dd");
                    }
                    catch (Exception ex)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR187");
                    }

                }
                if (!string.IsNullOrWhiteSpace(Date_LT))
                {
                    try
                    {
                        Date_LT = GlobalTool.LinuxToDate(Convert.ToDouble(Date_LT)).ToString("yyyy-MM-dd HH:mm:ss");
                        //Date_LT = DateTime.Parse(Date_LT).ToString("yyyy-MM-dd");
                    }
                    catch (Exception ex)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR188");
                    }
                }

                if (!string.IsNullOrWhiteSpace(Date_GT) && !string.IsNullOrWhiteSpace(Date_LT))
                {
                    if (DateTime.Parse(Date_GT) > DateTime.Parse(Date_LT))
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR189");
                    }
                }
            }
            catch (Exception ex)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR190");
            }

            #endregion

            DealReturn _DealReturn = new DealReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    string strSQL = "AND Business_Unit_Code IN (1) AND Deal_Workflow_Status <> 'AR' AND is_active ='Y'";

                    if (!string.IsNullOrWhiteSpace(search_value))
                    {
                        strSQL += " AND (agreement_no like '%" + search_value + "%'"
                                        + " or Entity_Code in (Select Entity_Code from Entity where Entity_Name like N'%" + search_value + "%')"
                                        + " or Vendor_Code in (Select Vendor_Code from Vendor where Vendor_Name like N'%" + search_value + "%')"
                                        + " or Acq_Deal_Code in (Select Acq_Deal_Code from Acq_Deal_Movie where Title_Code in (Select Title_Code from Title where Title_name  like N'%" + search_value + "%')))";

                        //strSQL += " And Business_Unit_Code In (select Business_Unit_Code from Users_Business_Unit where Users_Code=" + Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]) + ")";//AND is_active='Y';
                        strSQL += " And Business_Unit_Code In (select Business_Unit_Code from Users_Business_Unit where Users_Code=" + Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]) + ")";//AND is_active='Y';
                    }

                    if (!string.IsNullOrWhiteSpace(Date_GT) && !string.IsNullOrWhiteSpace(Date_LT))
                    {
                        strSQL += " AND ISNULL(Last_Updated_Time,Inserted_On) BETWEEN '" + Date_GT + "' AND '" + Date_LT + "'";
                    }
                    else if (!string.IsNullOrWhiteSpace(Date_GT))
                    {
                        strSQL += " AND ISNULL(Last_Updated_Time,Inserted_On) >= '" + Date_GT + "'";
                    }
                    else if (!string.IsNullOrWhiteSpace(Date_LT))
                    {
                        strSQL += " AND ISNULL(Last_Updated_Time,Inserted_On) <= '" + Date_LT + "'";
                    }

                    string strOrderbyCondition = string.Empty;

                    strOrderbyCondition = sort + " " + order.ToUpper();


                    _DealReturn = objDealRepositories.GetDeal_List(strSQL, page, strOrderbyCondition, size, Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]));

                    var deallist = (List<Acq_Deal_List>)_DealReturn.content;
                    deallist.ForEach(i =>
                    {
                        i.agreement_date = Convert.ToString(GlobalTool.DateToLinux(i.DealSignedDate));
                    });

                }
                else
                {
                    _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
                    for (int i = 0; i < _objRet.Errors.Count(); i++)
                    {
                        if (_objRet.Errors[i].Contains("ERR185"))
                        {
                            _objRet.Errors[i] = _objRet.Errors[i].Replace("{0}", ConfigurationManager.AppSettings["maxSize"]);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _DealReturn.paging.page = page;
            _DealReturn.paging.size = size;

            _objRet.Response = _DealReturn;

            return _objRet;
        }

        public GenericReturn GetById(Int32? deal_id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (deal_id == null || deal_id <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR178");
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal objDealGeneral = new Acq_Deal();

                    objDealGeneral = objDealRepositories.Get(deal_id.Value);

                    if (objDealGeneral != null)
                    {
                        objDealGeneral.agreement_date = Convert.ToString(GlobalTool.DateToLinux(objDealGeneral.Agreement_Date.Value));
                        //objDealGeneral.inserted_on = Convert.ToString(GlobalTool.DateToLinux(objDealGeneral.Inserted_On.Value));
                        //objDealGeneral.updated_on = Convert.ToString(GlobalTool.DateToLinux(objDealGeneral.Last_Updated_Time.Value));
                        //objDealGeneral.action_by = objDealGeneral.Inserted_By != null || objDealGeneral.Inserted_By.Value > 0 ? objDealGeneral.Inserted_By : objDealGeneral.Last_Action_By;
                    }
                    else
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR183");
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
                _objRet = GlobalTool.SetError(_objRet, "ERR154");
            }

            if (string.IsNullOrWhiteSpace(objInput.agreement_date))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR156");
            }
            else
            {
                try
                {
                    objInput.Agreement_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.agreement_date));
                }
                catch (Exception ex)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR157");
                }
            }

            if (string.IsNullOrWhiteSpace(objInput.Deal_Desc))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR158");
            }

            if (objInput.Deal_Tag_Code == null || objInput.Deal_Tag_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR159");
            }

            if (string.IsNullOrWhiteSpace(objInput.Is_Master_Deal))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR160");
            }
            else
            {
                if (objInput.Is_Master_Deal.ToUpper() == "N")
                {
                    if (objInput.Master_Deal_Movie_Code_ToLink == null || objInput.Master_Deal_Movie_Code_ToLink <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR165");
                    }
                }
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
                _objRet = GlobalTool.SetError(_objRet, "ERR161");
            }

            if (objInput.Deal_Type_Code == null || objInput.Deal_Type_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR162");
            }

            if (objInput.Entity_Code == null || objInput.Entity_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR163");
            }

            if (objInput.Vendor_Code == null || objInput.Vendor_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR164");
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

            if (string.IsNullOrWhiteSpace(objInput.Year_Type))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR166");
            }

            if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR167");
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
                _objRet = GlobalTool.SetError(_objRet, "ERR168");
            }

            if (objInput.Category_Code == null || objInput.Category_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR169");
            }

            //if (string.IsNullOrWhiteSpace(objInput.Deal_Workflow_Status))
            //{
            //    _objRet.Message = "Input Paramater 'workflow_status' is mandatory";
            //    _objRet.IsSuccess = false;
            //    _objRet.StatusCode = HttpStatusCode.BadRequest;
            //    return _objRet;
            //}

            if (objInput.licensors == null || objInput.licensors.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR170");
            }
            else
            {
                for (int i = 0; i < objInput.licensors.ToList().Count(); i++)
                {
                    if (objInput.licensors.ToList()[i].Vendor_Code == null || objInput.licensors.ToList()[i].Vendor_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR171");
                    }
                }
            }

            if (objInput.titles == null || objInput.titles.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR172");
            }
            else
            {
                for (int i = 0; i < objInput.titles.ToList().Count(); i++)
                {
                    if (objInput.titles.ToList()[i].Title_Code == null || objInput.titles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR173");
                    }

                    if (objInput.titles.ToList()[i].Episode_Starts_From == null || objInput.titles.ToList()[i].Episode_Starts_From <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR174");
                    }

                    if (objInput.titles.ToList()[i].Episode_End_To == null || objInput.titles.ToList()[i].Episode_End_To <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR175");
                    }
                }
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                objInput.Agreement_No = string.Empty;
                objInput.Version = "0001";

                #region Pending Columns

                objInput.Attach_Workflow = null;
                objInput.Work_Flow_Code = null;
                objInput.Amendment_Date = null;
                objInput.Is_Released = null;
                objInput.Release_On = null;
                objInput.Release_By = null;
                objInput.Is_Completed = null;
                objInput.Is_Active = "Y";
                objInput.Content_Type = null;
                objInput.Payment_Terms_Conditions = null;
                objInput.Status = "O";
                objInput.Is_Auto_Generated = "N";
                objInput.Is_Migrated = "N";
                objInput.Cost_Center_Id = null;
                objInput.BudgetWise_Costing_Applicable = "N";
                objInput.Validate_CostWith_Budget = "N";
                objInput.Payment_Remarks = null;
                objInput.Deal_Complete_Flag = new SystemParameterServices().GetSystemParameterList().Where(x => x.Parameter_Name.ToUpper() == "Deal_Complete_Flag".ToUpper()).FirstOrDefault().Parameter_Value;
                objInput.All_Channel = null;
                objInput.Channel_Cluster_Code = null;
                objInput.Is_Auto_Push = "N";
                objInput.Deal_Segment_Code = null;
                objInput.Revenue_Vertical_Code = null;
                objInput.Confirming_Party = null;
                objInput.Material_Remarks = null;

                #endregion

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
                _objRet = GlobalTool.SetError(_objRet, "ERR154");
            }

            if (objInput.Acq_Deal_Code == null || objInput.Acq_Deal_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR178");
            }

            if (string.IsNullOrWhiteSpace(objInput.agreement_date))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR156");
            }
            else
            {
                try
                {
                    objInput.Agreement_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.agreement_date));
                }
                catch (Exception ex)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR157");
                }
            }

            if (string.IsNullOrWhiteSpace(objInput.Deal_Desc))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR158");
            }

            if (objInput.Deal_Tag_Code == null || objInput.Deal_Tag_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR159");
            }

            if (string.IsNullOrWhiteSpace(objInput.Is_Master_Deal))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR160");
            }
            else
            {
                if (objInput.Is_Master_Deal != null && objInput.Is_Master_Deal.ToUpper() == "N")
                {
                    if (objInput.Master_Deal_Movie_Code_ToLink == null || objInput.Master_Deal_Movie_Code_ToLink <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR165");
                    }
                }
            }

            if (objInput.Role_Code == null || objInput.Role_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR161");
            }

            if (objInput.Deal_Type_Code == null || objInput.Deal_Type_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR162");
            }

            if (objInput.Entity_Code == null || objInput.Entity_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR163");
            }

            if (objInput.Vendor_Code == null || objInput.Vendor_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR164");
            }

            if (string.IsNullOrWhiteSpace(objInput.Year_Type))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR166");
            }

            if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR167");
            }

            if (objInput.Business_Unit_Code == null || objInput.Business_Unit_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR168");
            }

            if (objInput.Category_Code == null || objInput.Category_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR169");
            }

            if (objInput.licensors == null || objInput.licensors.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR170");
            }
            else
            {
                for (int i = 0; i < objInput.licensors.ToList().Count(); i++)
                {
                    if (objInput.licensors.ToList()[i].Vendor_Code == null || objInput.licensors.ToList()[i].Vendor_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR171");
                    }
                }
            }

            if (objInput.titles == null || objInput.titles.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR172");
            }
            else
            {
                for (int i = 0; i < objInput.titles.ToList().Count(); i++)
                {
                    if (objInput.titles.ToList()[i].Title_Code == null || objInput.titles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR173");
                    }

                    if (objInput.titles.ToList()[i].Episode_Starts_From == null || objInput.titles.ToList()[i].Episode_Starts_From <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR174");
                    }

                    if (objInput.titles.ToList()[i].Episode_End_To == null || objInput.titles.ToList()[i].Episode_End_To <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR175");
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

                    #region Pending Columns

                    objInput.Attach_Workflow = objDeal.Attach_Workflow;
                    objInput.Work_Flow_Code = objDeal.Work_Flow_Code;
                    objInput.Amendment_Date = objDeal.Amendment_Date;
                    objInput.Is_Released = objDeal.Is_Released;
                    objInput.Release_On = objDeal.Release_On;
                    objInput.Release_By = objDeal.Release_By;
                    objInput.Is_Completed = objDeal.Is_Completed;
                    objInput.Is_Active = objDeal.Is_Active;
                    objInput.Content_Type = objDeal.Content_Type;
                    objInput.Payment_Terms_Conditions = objDeal.Payment_Terms_Conditions;
                    objInput.Status = objDeal.Status;
                    objInput.Is_Auto_Generated = objDeal.Is_Auto_Generated;
                    objInput.Is_Migrated = objDeal.Is_Migrated;
                    objInput.Cost_Center_Id = objDeal.Cost_Center_Id;
                    objInput.BudgetWise_Costing_Applicable = objDeal.BudgetWise_Costing_Applicable;
                    objInput.Validate_CostWith_Budget = objDeal.Validate_CostWith_Budget;
                    objInput.Payment_Remarks = objDeal.Payment_Remarks;
                    objInput.Deal_Complete_Flag = objDeal.Deal_Complete_Flag;
                    objInput.All_Channel = objDeal.All_Channel;
                    objInput.Channel_Cluster_Code = objDeal.Channel_Cluster_Code;
                    objInput.Is_Auto_Push = objDeal.Is_Auto_Push;
                    objInput.Deal_Segment_Code = objDeal.Deal_Segment_Code;
                    objInput.Revenue_Vertical_Code = objDeal.Revenue_Vertical_Code;
                    objInput.Confirming_Party = objDeal.Confirming_Party;
                    objInput.Material_Remarks = objDeal.Material_Remarks;

                    #endregion

                    objInput.Inserted_On = objDeal.Inserted_On;
                    objInput.Inserted_By = objDeal.Inserted_By;
                    objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                    objInput.Last_Updated_Time = DateTime.Now;
                    objInput.Is_Active = objDeal.Is_Active;

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
                    _objRet = GlobalTool.SetError(_objRet, "ERR183");
                }
                _objRet.id = objInput.Acq_Deal_Code;
            }

            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

            return _objRet;
        }

        public GenericReturn Delete(Int32? deal_id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (deal_id == null || deal_id <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR178");
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal objDealGeneral = new Acq_Deal();

                    objDealGeneral = objDealRepositories.Get(deal_id.Value);

                    if (objDealGeneral != null)
                    {
                        objDealRepositories.Delete(objDealGeneral);

                        _objRet.id = objDealGeneral.Acq_Deal_Code;
                    }
                    else
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR183");
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

        public GenericReturn DealCompeteStatus(int? deal_id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (deal_id == null || deal_id <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR178");
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal objDeal = new Acq_Deal();
                    bool is_RightCompleted = true;

                    objDeal = objDealRepositories.Get(deal_id.Value);

                    if (objDeal != null)
                    {
                        #region Right Validation Completion Check

                        var lstdeal_rights = objDealRightsRepositories.SearchFor(new { Acq_Deal_Code = objDeal.Acq_Deal_Code }).ToList();
                        if (lstdeal_rights.Count() > 0)
                        {
                            lstdeal_rights.ForEach(i =>
                            {
                                if (i.Right_Status.ToUpper() != "C")
                                {
                                    is_RightCompleted = false;
                                }
                            });

                            if (!is_RightCompleted)
                            {
                                _objRet = GlobalTool.SetError(_objRet, "ERR250");
                            }
                        }
                        else
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR248");
                        }

                        #endregion

                        #region Rights available in all titles Check

                        List<string> lstRightTitles = new List<string>();
                        List<string> lstDealTitles = new List<string>();

                        objDeal.titles.ToList().ForEach(i =>
                        {
                            lstDealTitles.Add(i.Title_Code + "~" + i.Episode_Starts_From + "~" + i.Episode_End_To);
                        });

                        lstdeal_rights.ForEach(i =>
                        {
                            lstRightTitles.Add(i.Titles.Select(x => x.Title_Code.Value + "~" + x.Episode_From + "~" + x.Episode_To).Distinct().FirstOrDefault());
                        });

                        lstRightTitles = lstRightTitles.Distinct().ToList();

                        int cntremainingTitle = lstDealTitles.Distinct().Except(lstRightTitles).Count();
                        if (cntremainingTitle > 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR253");
                        }

                        #endregion

                        #region Checking Liner Rights for run defination

                        List<string> lstLinerTitle = new List<string>();

                        if (objDeal.Deal_Complete_Flag.Contains("R, R"))
                        {
                            lstdeal_rights.ForEach(i =>
                            {
                                if (i.Platform.Where(x => x.platform.Is_No_Of_Run == "Y").Count() > 0)
                                {
                                    lstLinerTitle.Add(i.Titles.Select(x => x.Title_Code + "~" + x.Episode_From + "~" + x.Episode_To).Distinct().FirstOrDefault());
                                }
                            });

                            List<string> lstRunTitle = new List<string>();

                            var lstAcqDealRuns = new AcqDealRunRepositories().SearchFor(new { Acq_Deal_Code = objDeal.Acq_Deal_Code }).ToList();

                            lstRunTitle = lstAcqDealRuns.Select(x => x.titles.Select(c => c.Title_Code + "~" + c.Episode_From + "~" + c.Episode_To).FirstOrDefault()).ToList();

                            int cntRunTitle = lstLinerTitle.Distinct().Except(lstRunTitle).Count();

                            if (cntRunTitle > 0)
                            {
                                _objRet = GlobalTool.SetError(_objRet, "ERR279");
                            }
                        }



                        #endregion

                        _objRet.id = objDeal.Acq_Deal_Code;
                    }
                    else
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR183");
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

        public GenericReturn rollback(Acq_Deal objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Acq_Deal_Code == null || objInput.Acq_Deal_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR178");
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    var message = objDealRepositories.validate_Rollback(objInput.Acq_Deal_Code.Value, "A", Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]));

                    if (!string.IsNullOrWhiteSpace(message))
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR300");
                    }

                    _objRet.id = objInput.Acq_Deal_Code;
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

        public GenericReturn candeletetitle(int? deal_id, int? title_id, int? episode_from, int? episode_to)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            string strValidationMessage = string.Empty;

            #region Input Validation

            if (deal_id == null || deal_id <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR178");
            }

            if (title_id == null || title_id <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR194");
            }

            if (episode_from == null || episode_from <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR301");
            }

            if (episode_to == null || episode_to <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR302");
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    var message = objDealRepositories.validate_General_Delete_For_Title(deal_id.Value, title_id.Value, episode_from.Value, episode_to.Value, "A");

                    if (message.Status.ToUpper() == "E")
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR303");
                        strValidationMessage = message.Message;
                    }

                    _objRet.id = deal_id;
                }

                if (!_objRet.IsSuccess)
                {
                    _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
                    for (int i = 0; i < _objRet.Errors.Count(); i++)
                    {
                        if (_objRet.Errors[i].Contains("ERR303"))
                        {
                            _objRet.Errors[i] = _objRet.Errors[i].Replace("{deal_candeletetitle}", strValidationMessage);
                        }
                    }
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
