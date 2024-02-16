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
    public class SynDealServices
    {
        private readonly SynDealRepositories objSynDealRepositories = new SynDealRepositories();
        private readonly Syn_Deal_MovieRepositories objSyn_Deal_MovieRepositories = new Syn_Deal_MovieRepositories();

        public GenericReturn Post(Syn_Deal objInput)
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
            else
            {
                if (objInput.Deal_Type_Code == null || objInput.Deal_Type_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR162");
                }

                if (objInput.Business_Unit_Code == null || objInput.Business_Unit_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR168");
                }

                if (string.IsNullOrWhiteSpace(objInput.agreement_date))
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR156");
                }
                else
                {
                    try
                    {
                        objInput.Agreement_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.agreement_date)).Date;
                    }
                    catch (Exception ex)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR157");
                    }
                }

                if (string.IsNullOrWhiteSpace(objInput.Deal_Description))
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR158");
                }

                if (string.IsNullOrWhiteSpace(objInput.Year_Type))
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR166");
                }

                if (objInput.Customer_Type == null || objInput.Customer_Type <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR311");
                }

                if (objInput.Vendor_Code == null || objInput.Vendor_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR310");
                }

                if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR167");
                }

                if (objInput.Category_Code == null || objInput.Category_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR169");
                }

                if (objInput.Deal_Tag_Code == null || objInput.Deal_Tag_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR159");
                }

                if (objInput.Deal_Segment_Code == null || objInput.Deal_Segment_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR312");
                }

                if (objInput.Revenue_Vertical_Code == null || objInput.Revenue_Vertical_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR313");
                }
                                
                if (objInput.SynDealTitles == null || objInput.SynDealTitles.Count() == 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR314");
                }
                else
                {
                    for (int i = 0; i < objInput.SynDealTitles.ToList().Count(); i++)
                    {
                        if (objInput.SynDealTitles.ToList()[i].Title_Code == null || objInput.SynDealTitles.ToList()[i].Title_Code <= 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR315");
                        }

                        if (objInput.SynDealTitles.ToList()[i].Episode_From == null || objInput.SynDealTitles.ToList()[i].Episode_From <= 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR316");
                        }

                        if (objInput.SynDealTitles.ToList()[i].Episode_End_To == null || objInput.SynDealTitles.ToList()[i].Episode_End_To <= 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR317");
                        }
                    }
                }
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                objInput.Agreement_No = string.Empty;
                objInput.Version = "0001";

                #region Pending Columns

                objInput.Other_Deal = null;
                objInput.Total_Sale = null;
                objInput.Attach_Workflow = "Y";
                objInput.Deal_Workflow_Status = "N";
                objInput.Work_Flow_Code = 112;
                objInput.Is_Completed = "N";
                objInput.Parent_Syn_Deal_Code = null;
                objInput.Is_Migrated = "N";
                objInput.Ref_BMS_Code = null;
                objInput.Status = "O";
                objInput.Is_Active = "Y";
                objInput.Payment_Remarks = null;
                objInput.Deal_Complete_Flag = "R";
                objInput.Entity_Code = new UserServices().GetUserByID(Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"])).Default_Entity_Code;
                objInput.Role_Code = null;

                #endregion

                objInput.Inserted_On = DateTime.Now;
                objInput.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Last_Updated_Time = DateTime.Now;
                objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                
                List<Syn_Deal_Movie> lstDealTitles = new List<Syn_Deal_Movie>();
                foreach (var item in objInput.SynDealTitles)
                {
                    Syn_Deal_Movie objDealTitle = new Syn_Deal_Movie();
                    objDealTitle.Syn_Deal_Code = item.Syn_Deal_Code;
                    objDealTitle.Title_Code = item.Title_Code;
                    objDealTitle.Episode_From = item.Episode_From;
                    objDealTitle.Episode_End_To = item.Episode_End_To;
                    objDealTitle.Syn_Title_Type = item.Syn_Title_Type;                                        
                    objDealTitle.Is_Closed = "N";
                    lstDealTitles.Add(objDealTitle);
                }
                objInput.SynDealTitles = lstDealTitles;

                objSynDealRepositories.Add(objInput);

                _objRet.id = objInput.Syn_Deal_Code;
            }

            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

            return _objRet;
        }

        public GenericReturn Put(Syn_Deal objInput)
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
            else
            {
                if (objInput.Syn_Deal_Code == null || objInput.Syn_Deal_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR178");
                }

                if (objInput.Deal_Type_Code == null || objInput.Deal_Type_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR162");
                }

                if (objInput.Business_Unit_Code == null || objInput.Business_Unit_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR168");
                }

                if (string.IsNullOrWhiteSpace(objInput.agreement_date))
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR156");
                }
                else
                {
                    try
                    {
                        objInput.Agreement_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.agreement_date)).Date;
                    }
                    catch (Exception ex)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR157");
                    }
                }

                if (string.IsNullOrWhiteSpace(objInput.Deal_Description))
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR158");
                }

                if (string.IsNullOrWhiteSpace(objInput.Year_Type))
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR166");
                }

                if (objInput.Customer_Type == null || objInput.Customer_Type <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR311");
                }

                if (objInput.Vendor_Code == null || objInput.Vendor_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR310");
                }

                if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR167");
                }

                if (objInput.Category_Code == null || objInput.Category_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR169");
                }

                if (objInput.Deal_Tag_Code == null || objInput.Deal_Tag_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR159");
                }

                if (objInput.Deal_Segment_Code == null || objInput.Deal_Segment_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR312");
                }

                if (objInput.Revenue_Vertical_Code == null || objInput.Revenue_Vertical_Code <= 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR313");
                }

                if (objInput.SynDealTitles == null || objInput.SynDealTitles.Count() == 0)
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR314");
                }
                else
                {
                    for (int i = 0; i < objInput.SynDealTitles.ToList().Count(); i++)
                    {
                        if (objInput.SynDealTitles.ToList()[i].Title_Code == null || objInput.SynDealTitles.ToList()[i].Title_Code <= 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR315");
                        }

                        if (objInput.SynDealTitles.ToList()[i].Episode_From == null || objInput.SynDealTitles.ToList()[i].Episode_From <= 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR316");
                        }

                        if (objInput.SynDealTitles.ToList()[i].Episode_End_To == null || objInput.SynDealTitles.ToList()[i].Episode_End_To <= 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR317");
                        }
                    }
                }
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                var objDeal = objSynDealRepositories.Get(objInput.Syn_Deal_Code.Value);

                if (objDeal != null)
                {
                    objInput.Agreement_No = objDeal.Agreement_No;
                    objInput.Version = objDeal.Version;

                    #region Pending Columns

                    objInput.Other_Deal = objDeal.Other_Deal;
                    objInput.Total_Sale = objDeal.Total_Sale;
                    objInput.Attach_Workflow = objDeal.Attach_Workflow;
                    objInput.Deal_Workflow_Status = objDeal.Deal_Workflow_Status;
                    objInput.Work_Flow_Code = objDeal.Work_Flow_Code;
                    objInput.Is_Completed = objDeal.Is_Completed;
                    objInput.Parent_Syn_Deal_Code = objDeal.Parent_Syn_Deal_Code;
                    objInput.Is_Migrated = objDeal.Is_Migrated;
                    objInput.Ref_BMS_Code = objDeal.Ref_BMS_Code;
                    objInput.Status = objDeal.Status;
                    objInput.Is_Active = objDeal.Is_Active;
                    objInput.Payment_Remarks = objDeal.Payment_Remarks;
                    objInput.Deal_Complete_Flag = objDeal.Deal_Complete_Flag;
                    objInput.Entity_Code = objDeal.Entity_Code;
                    objInput.Role_Code = objDeal.Role_Code;

                    #endregion

                    objInput.Inserted_On = objDeal.Inserted_On;
                    objInput.Inserted_By = objDeal.Inserted_By;
                    objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                    objInput.Last_Updated_Time = DateTime.Now;
                    objInput.Is_Active = objDeal.Is_Active;

                    #region Syn_Deal_Movie

                    objDeal.SynDealTitles.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.SynDealTitles)
                    {
                        Syn_Deal_Movie objT = (Syn_Deal_Movie)objDeal.SynDealTitles.Where(t => t.Title_Code == item.Title_Code).Select(i => i).FirstOrDefault();

                        if (objT == null)
                            objT = new Syn_Deal_Movie();
                        if (objT.Syn_Deal_Movie_Code > 0)
                        {
                            objT.EntityState = State.Unchanged;
                            objT.Syn_Deal_Code = objInput.Syn_Deal_Code;
                            objT.Title_Code = item.Title_Code;
                            objT.Episode_From = item.Episode_From;
                            objT.Episode_End_To = item.Episode_End_To;                            
                            objT.Syn_Title_Type = item.Syn_Title_Type;                            
                        }
                        else
                        {
                            objT.EntityState = State.Added;
                            objT.Syn_Deal_Code = objInput.Syn_Deal_Code;
                            objT.Title_Code = item.Title_Code;
                            objT.Episode_From = item.Episode_From;
                            objT.Episode_End_To = item.Episode_End_To;                            
                            objT.Syn_Title_Type = item.Syn_Title_Type;                            
                            objDeal.SynDealTitles.Add(objT);
                        }
                    }

                    foreach (var item in objDeal.SynDealTitles.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objSyn_Deal_MovieRepositories.Delete(item);
                    }

                    var objDealTitle = objDeal.SynDealTitles.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objDealTitle.ForEach(i => objDeal.SynDealTitles.Remove(i));

                    objInput.SynDealTitles = objDeal.SynDealTitles;

                    #endregion

                    objSynDealRepositories.Update(objInput);
                }
                else
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR183");
                }
                _objRet.id = objInput.Syn_Deal_Code;
            }

            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

            return _objRet;
        }
    }
}
