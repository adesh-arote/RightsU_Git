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

namespace RightsU.BMS.BLL.Services
{
    public class DealGeneralServices
    {
        private readonly DealGeneralRepositories objDealGeneralRepositories = new DealGeneralRepositories();

        public GenericReturn GetById(Int32 id)
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
                    Acq_Deal objDealGeneral = new Acq_Deal();

                    objDealGeneral = objDealGeneralRepositories.GetById(id);

                    objDealGeneral.agreement_date = Convert.ToString(GlobalTool.DateToLinux(objDealGeneral.Agreement_Date.Value));
                    objDealGeneral.inserted_on = Convert.ToString(GlobalTool.DateToLinux(objDealGeneral.Inserted_On.Value));
                    objDealGeneral.updated_on = Convert.ToString(GlobalTool.DateToLinux(objDealGeneral.Last_Updated_Time.Value));

                    _objRet.Response = objDealGeneral;
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

            if (string.IsNullOrEmpty(objInput.agreement_date))
            {
                _objRet.Message = "Input Paramater 'agreement_date' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                try
                {
                    objInput.Agreement_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.agreement_date));
                }
                catch (Exception ex)
                {
                    _objRet.Message = "Input Paramater 'agreement_date' is invalid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (string.IsNullOrEmpty(objInput.Deal_Desc))
            {
                _objRet.Message = "Input Paramater 'deal_description' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Deal_Tag_Code == null || objInput.Deal_Tag_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'deal_tag_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Is_Master_Deal))
            {
                _objRet.Message = "Input Paramater 'master_sub_deal_type' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Is_Master_Deal.ToUpper() != "Y" && objInput.Is_Master_Deal.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'master_sub_deal_type' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Role_Code == null || objInput.Role_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'role_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Deal_Type_Code == null || objInput.Deal_Type_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'deal_type_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Entity_Code == null || objInput.Entity_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'entity_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Vendor_Code == null || objInput.Vendor_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'primary_vendor_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Is_Master_Deal.ToUpper() == "N")
            {
                if (objInput.Parent_Deal_Code == null || objInput.Parent_Deal_Code <= 0)
                {
                    _objRet.Message = "Input Paramater 'master_deal_id' is mandatory";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.Is_Master_Deal.ToUpper() == "N")
            {
                if (objInput.Master_Deal_Movie_Code_ToLink == null || objInput.Master_Deal_Movie_Code_ToLink <= 0)
                {
                    _objRet.Message = "Input Paramater 'master_deal_link_title_id' is mandatory";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (string.IsNullOrEmpty(objInput.Year_Type))
            {
                _objRet.Message = "Input Paramater 'year_definition' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'currency_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Exchange_Rate == null || objInput.Exchange_Rate <= 0)
            {
                _objRet.Message = "Input Paramater 'exchange_rate' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Business_Unit_Code == null || objInput.Business_Unit_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'business_unit_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Category_Code == null || objInput.Category_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'category_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Deal_Workflow_Status))
            {
                _objRet.Message = "Input Paramater 'workflow_status' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            //if (string.IsNullOrEmpty(objInput.Ref_BMS_Code))
            //{
            //    _objRet.Message = "Input Paramater 'ref_system_id' is mandatory";
            //    _objRet.IsSuccess = false;
            //    _objRet.StatusCode = HttpStatusCode.BadRequest;
            //    return _objRet;
            //}

            if (objInput.Licensors.Count() == 0)
            {
                _objRet.Message = "Input Paramater 'Licensors' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                for (int i = 0; i < objInput.Licensors.ToList().Count(); i++)
                {
                    //if (objInput.Licensors.ToList()[i].Acq_Deal_Code == null || objInput.Licensors.ToList()[i].Acq_Deal_Code <= 0)
                    //{
                    //    _objRet.Message = "Input Paramater 'Licensors.deal_id' is mandatory";
                    //    _objRet.IsSuccess = false;
                    //    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //    return _objRet;
                    //}

                    if (objInput.Licensors.ToList()[i].Vendor_Code == null || objInput.Licensors.ToList()[i].Vendor_Code <= 0)
                    {
                        _objRet.Message = "Input Paramater 'Licensors.licensor_id' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }
                }
            }

            if (objInput.DealTitles.Count() == 0)
            {
                _objRet.Message = "Input Paramater 'DealTitles' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                for (int i = 0; i < objInput.DealTitles.ToList().Count(); i++)
                {
                    //if (objInput.DealTitles.ToList()[i].Acq_Deal_Code == null || objInput.DealTitles.ToList()[i].Acq_Deal_Code <= 0)
                    //{
                    //    _objRet.Message = "Input Paramater 'DealTitles.deal_id' is mandatory";
                    //    _objRet.IsSuccess = false;
                    //    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //    return _objRet;
                    //}

                    if (objInput.DealTitles.ToList()[i].Title_Code == null || objInput.DealTitles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.title_id' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (objInput.DealTitles.ToList()[i].Episode_Starts_From == null || objInput.DealTitles.ToList()[i].Episode_Starts_From <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.episode_from' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (objInput.DealTitles.ToList()[i].Episode_End_To == null || objInput.DealTitles.ToList()[i].Episode_End_To <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.episode_to' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (string.IsNullOrEmpty(objInput.DealTitles.ToList()[i].Title_Type))
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.title_type' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (string.IsNullOrEmpty(objInput.DealTitles.ToList()[i].Due_Diligence))
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.public_notice' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    //if (string.IsNullOrEmpty(objInput.DealTitles.ToList()[i].Inserted_On))
                    //{
                    //    _objRet.Message = "Input Paramater 'DealTitles.inserted_on' is mandatory";
                    //    _objRet.IsSuccess = false;
                    //    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //    return _objRet;
                    //}
                    //else
                    //{
                    //    try
                    //    {
                    //        objInput.DealTitles.ToList()[i].Inserted_On = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.DealTitles.ToList()[i].Inserted_On)).ToString("yyyy-MM-dd");
                    //    }
                    //    catch (Exception ex)
                    //    {
                    //        _objRet.Message = "Input Paramater 'DealTitles.inserted_on' is invalid";
                    //        _objRet.IsSuccess = false;
                    //        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //        return _objRet;
                    //    }
                    //}

                    //if (objInput.DealTitles.ToList()[i].Inserted_By == null || objInput.DealTitles.ToList()[i].Inserted_By <= 0)
                    //{
                    //    _objRet.Message = "Input Paramater 'DealTitles.inserted_by' is mandatory";
                    //    _objRet.IsSuccess = false;
                    //    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //    return _objRet;
                    //}
                }
            }

            if (string.IsNullOrEmpty(objInput.inserted_on))
            {
                _objRet.Message = "Input Paramater 'inserted_on' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                try
                {
                    objInput.Inserted_On = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.inserted_on));
                }
                catch (Exception ex)
                {
                    _objRet.Message = "Input Paramater 'inserted_on' is invalid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.Inserted_By == null || objInput.Inserted_By <= 0)
            {
                _objRet.Message = "Input Paramater 'inserted_by' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }


            #endregion

            if (_objRet.IsSuccess)
            {
                objInput.Version = "0001";
                objInput.Last_Updated_Time = objInput.Inserted_On;
                objInput.Last_Action_By = objInput.Inserted_By;


                List<Acq_Deal_Licensor> lstLicensors = new List<Acq_Deal_Licensor>();
                foreach (var item in objInput.Licensors)
                {
                    Acq_Deal_Licensor objLicensor = new Acq_Deal_Licensor();

                    objLicensor.Acq_Deal_Code = item.Acq_Deal_Code;
                    objLicensor.Vendor_Code = item.Vendor_Code;
                    lstLicensors.Add(objLicensor);
                }
                objInput.Licensors = lstLicensors;

                List<Acq_Deal_Movie> lstDealTitles = new List<Acq_Deal_Movie>();
                foreach (var item in objInput.DealTitles)
                {
                    Acq_Deal_Movie objDealTitle = new Acq_Deal_Movie();
                    objDealTitle.Acq_Deal_Code = item.Acq_Deal_Code;
                    objDealTitle.Title_Code = item.Title_Code;
                    objDealTitle.Episode_Starts_From = item.Episode_Starts_From;
                    objDealTitle.Episode_End_To = item.Episode_End_To;
                    objDealTitle.Notes = item.Notes;
                    objDealTitle.Title_Type = item.Title_Type;
                    objDealTitle.Due_Diligence = item.Due_Diligence;
                    objDealTitle.Inserted_On = item.Inserted_On;
                    objDealTitle.Inserted_By = item.Inserted_By;
                    objDealTitle.Last_UpDated_Time = item.Last_UpDated_Time;
                    objDealTitle.Last_Action_By = item.Last_Action_By;
                    lstDealTitles.Add(objDealTitle);
                }
                objInput.DealTitles = lstDealTitles;
                                
                objDealGeneralRepositories.Add(objInput);

                _objRet.Response = new { id = objInput.Acq_Deal_Code };                
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

            if (objInput.Acq_Deal_Code == null || objInput.Acq_Deal_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'deal_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.agreement_date))
            {
                _objRet.Message = "Input Paramater 'agreement_date' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                try
                {
                    objInput.Agreement_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.agreement_date));
                }
                catch (Exception ex)
                {
                    _objRet.Message = "Input Paramater 'agreement_date' is invalid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (string.IsNullOrEmpty(objInput.Deal_Desc))
            {
                _objRet.Message = "Input Paramater 'deal_description' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Deal_Tag_Code == null || objInput.Deal_Tag_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'deal_tag_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Is_Master_Deal))
            {
                _objRet.Message = "Input Paramater 'master_sub_deal_type' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Is_Master_Deal.ToUpper() != "Y" && objInput.Is_Master_Deal.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'master_sub_deal_type' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Role_Code == null || objInput.Role_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'role_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Deal_Type_Code == null || objInput.Deal_Type_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'deal_type_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Entity_Code == null || objInput.Entity_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'entity_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Vendor_Code == null || objInput.Vendor_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'primary_vendor_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Is_Master_Deal.ToUpper() == "N")
            {
                if (objInput.Parent_Deal_Code == null || objInput.Parent_Deal_Code <= 0)
                {
                    _objRet.Message = "Input Paramater 'master_deal_id' is mandatory";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.Is_Master_Deal.ToUpper() == "N")
            {
                if (objInput.Master_Deal_Movie_Code_ToLink == null || objInput.Master_Deal_Movie_Code_ToLink <= 0)
                {
                    _objRet.Message = "Input Paramater 'master_deal_link_title_id' is mandatory";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (string.IsNullOrEmpty(objInput.Year_Type))
            {
                _objRet.Message = "Input Paramater 'year_definition' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Currency_Code == null || objInput.Currency_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'currency_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Exchange_Rate == null || objInput.Exchange_Rate <= 0)
            {
                _objRet.Message = "Input Paramater 'exchange_rate' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Business_Unit_Code == null || objInput.Business_Unit_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'business_unit_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Category_Code == null || objInput.Category_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'category_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Deal_Workflow_Status))
            {
                _objRet.Message = "Input Paramater 'workflow_status' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Licensors.Count() == 0)
            {
                _objRet.Message = "Input Paramater 'Licensors' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                for (int i = 0; i < objInput.Licensors.ToList().Count(); i++)
                {
                    if (objInput.Licensors.ToList()[i].Acq_Deal_Code == null || objInput.Licensors.ToList()[i].Acq_Deal_Code <= 0)
                    {
                        _objRet.Message = "Input Paramater 'Licensors.deal_id' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (objInput.Licensors.ToList()[i].Vendor_Code == null || objInput.Licensors.ToList()[i].Vendor_Code <= 0)
                    {
                        _objRet.Message = "Input Paramater 'Licensors.licensor_id' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }
                }
            }

            if (objInput.DealTitles.Count() == 0)
            {
                _objRet.Message = "Input Paramater 'DealTitles' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                for (int i = 0; i < objInput.DealTitles.ToList().Count(); i++)
                {
                    if (objInput.DealTitles.ToList()[i].Acq_Deal_Code == null || objInput.DealTitles.ToList()[i].Acq_Deal_Code <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.deal_id' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (objInput.DealTitles.ToList()[i].Title_Code == null || objInput.DealTitles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.title_id' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (objInput.DealTitles.ToList()[i].Episode_Starts_From == null || objInput.DealTitles.ToList()[i].Episode_Starts_From <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.episode_from' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (objInput.DealTitles.ToList()[i].Episode_End_To == null || objInput.DealTitles.ToList()[i].Episode_End_To <= 0)
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.episode_to' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (string.IsNullOrEmpty(objInput.DealTitles.ToList()[i].Title_Type))
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.title_type' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    if (string.IsNullOrEmpty(objInput.DealTitles.ToList()[i].Due_Diligence))
                    {
                        _objRet.Message = "Input Paramater 'DealTitles.public_notice' is mandatory";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                        return _objRet;
                    }

                    //if (string.IsNullOrEmpty(objInput.DealTitles.ToList()[i].Inserted_On))
                    //{
                    //    _objRet.Message = "Input Paramater 'DealTitles.inserted_on' is mandatory";
                    //    _objRet.IsSuccess = false;
                    //    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //    return _objRet;
                    //}
                    //else
                    //{
                    //    try
                    //    {
                    //        objInput.DealTitles.ToList()[i].Inserted_On = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.DealTitles.ToList()[i].Inserted_On)).ToString("yyyy-MM-dd");
                    //    }
                    //    catch (Exception ex)
                    //    {
                    //        _objRet.Message = "Input Paramater 'DealTitles.inserted_on' is invalid";
                    //        _objRet.IsSuccess = false;
                    //        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //        return _objRet;
                    //    }
                    //}

                    //if (objInput.DealTitles.ToList()[i].Inserted_By == null || objInput.DealTitles.ToList()[i].Inserted_By <= 0)
                    //{
                    //    _objRet.Message = "Input Paramater 'DealTitles.inserted_by' is mandatory";
                    //    _objRet.IsSuccess = false;
                    //    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //    return _objRet;
                    //}
                }
            }

            //if (string.IsNullOrEmpty(objInput.inserted_on))
            //{
            //    _objRet.Message = "Input Paramater 'inserted_on' is mandatory";
            //    _objRet.IsSuccess = false;
            //    _objRet.StatusCode = HttpStatusCode.BadRequest;
            //    return _objRet;
            //}
            //else
            //{
            //    try
            //    {
            //        objInput.Inserted_On = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.inserted_on));
            //    }
            //    catch (Exception ex)
            //    {
            //        _objRet.Message = "Input Paramater 'inserted_on' is invalid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            //if (objInput.Inserted_By == null || objInput.Inserted_By <= 0)
            //{
            //    _objRet.Message = "Input Paramater 'inserted_by' is mandatory";
            //    _objRet.IsSuccess = false;
            //    _objRet.StatusCode = HttpStatusCode.BadRequest;
            //    return _objRet;
            //}


            #endregion

            if (_objRet.IsSuccess)
            {

                //var objTitle = objDealGeneralRepositories.GetById(objInput.Acq_Deal_Code);

                //objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                //objInput.Last_UpDated_Time = DateTime.Now;
                //objInput.Is_Active = "Y";

                //#region Title_Country

                //objTitle.title_country.ToList().ForEach(i => i.EntityState = State.Deleted);

                //foreach (var item in objInput.title_country)
                //{
                //    Title_Country objT = (Title_Country)objTitle.title_country.Where(t => t.Country_Code == item.Country_Code).Select(i => i).FirstOrDefault();

                //    if (objT == null)
                //        objT = new Title_Country();
                //    if (objT.Title_Country_Code > 0)
                //        objT.EntityState = State.Unchanged;
                //    else
                //    {
                //        objT.EntityState = State.Added;
                //        objT.Title_Code = objInput.Title_Code;
                //        objT.Country_Code = item.Country_Code;
                //        objTitle.title_country.Add(objT);
                //    }
                //}

                //foreach (var item in objTitle.title_country.ToList().Where(x => x.EntityState == State.Deleted))
                //{
                //    objTitle_CountryRepositories.Delete(item);
                //}

                //var objCountry = objTitle.title_country.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                //objCountry.ForEach(i => objTitle.title_country.Remove(i));

                //objInput.title_country = objTitle.title_country;

                //#endregion

                //#region Title_Talent

                //objTitle.title_talent.ToList().ForEach(i => i.EntityState = State.Deleted);

                //foreach (var item in objInput.title_talent)
                //{
                //    Title_Talent objT = (Title_Talent)objTitle.title_talent.Where(t => t.Talent_Code == item.Talent_Code).Select(i => i).FirstOrDefault();

                //    if (objT == null)
                //        objT = new Title_Talent();
                //    if (objT.Title_Talent_Code > 0)
                //        objT.EntityState = State.Unchanged;
                //    else
                //    {
                //        objT.EntityState = State.Added;
                //        objT.Title_Code = objInput.Title_Code;
                //        objT.Talent_Code = item.Talent_Code;
                //        objT.Role_Code = item.Role_Code;
                //        objTitle.title_talent.Add(objT);
                //    }
                //}

                //foreach (var item in objTitle.title_talent.ToList().Where(x => x.EntityState == State.Deleted))
                //{
                //    objTitle_TalentRepositories.Delete(item);
                //}

                //var objTalent = objTitle.title_talent.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                //objTalent.ForEach(i => objTitle.title_talent.Remove(i));

                //objInput.title_talent = objTitle.title_talent;

                //#endregion

                //#region Title_Geners

                //objTitle.title_genres.ToList().ForEach(i => i.EntityState = State.Deleted);

                //foreach (var item in objInput.title_genres)
                //{
                //    Title_Geners objT = (Title_Geners)objTitle.title_genres.Where(t => t.Genres_Code == item.Genres_Code).Select(i => i).FirstOrDefault();

                //    if (objT == null)
                //        objT = new Title_Geners();
                //    if (objT.Title_Geners_Code > 0)
                //        objT.EntityState = State.Unchanged;
                //    else
                //    {
                //        objT.EntityState = State.Added;
                //        objT.Title_Code = objInput.Title_Code;
                //        objT.Genres_Code = item.Genres_Code;
                //        objTitle.title_genres.Add(objT);
                //    }
                //}

                //foreach (var item in objTitle.title_genres.ToList().Where(x => x.EntityState == State.Deleted))
                //{
                //    objTitle_GenersRepositories.Delete(item);
                //}

                //var objGeners = objTitle.title_genres.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                //objGeners.ForEach(i => objTitle.title_genres.Remove(i));

                //objInput.title_genres = objTitle.title_genres;

                //#endregion

                //objTitleRepositories.Update(objInput);

                //_objRet.Response = new { id = objInput.Title_Code };

                //if (objInput.Title_Code != null && objInput.Title_Code > 0)
                //{
                //    var MapExtendedData = objMap_Extended_ColumnsRepositories.SearchFor(new { Record_Code = objInput.Title_Code }).ToList();

                //    MapExtendedData.ForEach(i => i.EntityState = State.Deleted);

                //    foreach (var Metadata in objInput.MetaData)
                //    {
                //        Map_Extended_Columns objT = (Map_Extended_Columns)MapExtendedData.Where(t => t.Columns_Code == Metadata.Columns_Code && t.EntityState != State.Added && t.EntityState != State.Unchanged).Select(i => i).FirstOrDefault();

                //        if (objT == null)
                //            objT = new Map_Extended_Columns();
                //        if (objT.Map_Extended_Columns_Code > 0)
                //        {
                //            objT.EntityState = State.Unchanged;

                //            objT.Row_No = Metadata.Row_No > 0 ? Metadata.Row_No : (int?)null;

                //            if (objT.extended_columns.Is_Ref == "N" && objT.extended_columns.Is_Defined_Values == "N" && objT.extended_columns.Is_Multiple_Select == "N")
                //            {
                //                string strColumnValue = string.Empty;

                //                if (!string.IsNullOrEmpty(Convert.ToString(Metadata.Column_Value)))
                //                {
                //                    strColumnValue = Convert.ToString(Metadata.Column_Value);

                //                    if (objT.extended_columns.Control_Type == "DATE")
                //                    {
                //                        strColumnValue = GlobalTool.LinuxToDate(Convert.ToDouble(strColumnValue)).ToString("dd-MMM-yyyy");
                //                    }
                //                }
                //                objT.Column_Value = strColumnValue;
                //            }
                //            else if (objT.extended_columns.Is_Ref == "Y" && objT.extended_columns.Is_Multiple_Select == "N")
                //            {
                //                objT.Columns_Value_Code = Metadata.Columns_Value_Code;
                //            }
                //            else if (objT.extended_columns.Is_Ref == "Y" && objT.extended_columns.Is_Multiple_Select == "Y")
                //            {
                //                objT.metadata_values.ToList().ForEach(i => i.EntityState = State.Deleted);

                //                foreach (var details in Metadata.metadata_values)
                //                {
                //                    Map_Extended_Columns_Details objMECD = (Map_Extended_Columns_Details)objT.metadata_values.Where(t => t.Columns_Value_Code == details.Columns_Value_Code).Select(i => i).FirstOrDefault();

                //                    if (objMECD == null)
                //                        objMECD = new Map_Extended_Columns_Details();
                //                    if (objMECD.Map_Extended_Columns_Details_Code > 0)
                //                        objMECD.EntityState = State.Unchanged;
                //                    else
                //                    {
                //                        objT.EntityState = State.Added;
                //                        objMECD.Columns_Value_Code = details.Columns_Value_Code;
                //                        objMECD.Map_Extended_Columns_Code = objT.Map_Extended_Columns_Code;

                //                        objT.metadata_values.Add(objMECD);
                //                    }
                //                }

                //                foreach (var item in objT.metadata_values.ToList().Where(x => x.EntityState == State.Deleted))
                //                {
                //                    objMap_Extended_Columns_DetailsRepositories.Delete(item);
                //                }

                //                var objdetails = objT.metadata_values.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                //                foreach (var deleted in objdetails)
                //                {
                //                    objT.metadata_values.Remove(deleted);
                //                }
                //            }
                //        }
                //        else
                //        {
                //            var objExtendedColumn = objExtendedColumnsRepositories.Get(Metadata.Columns_Code.Value);

                //            objT.EntityState = State.Added;
                //            objT.Record_Code = objInput.Title_Code;
                //            objT.Table_Name = "TITLE";
                //            objT.Columns_Code = Metadata.Columns_Code;
                //            objT.extended_columns = objExtendedColumn;
                //            objT.Is_Multiple_Select = objExtendedColumn.Is_Multiple_Select;
                //            objT.Row_No = Metadata.Row_No > 0 ? Metadata.Row_No : (int?)null;

                //            if (objExtendedColumn.Is_Ref == "N" && objExtendedColumn.Is_Defined_Values == "N" && objExtendedColumn.Is_Multiple_Select == "N")
                //            {
                //                string strColumnValue = string.Empty;

                //                if (!string.IsNullOrEmpty(Convert.ToString(Metadata.Column_Value)))
                //                {
                //                    strColumnValue = Convert.ToString(Metadata.Column_Value);

                //                    if (objExtendedColumn.Control_Type == "DATE")
                //                    {
                //                        strColumnValue = GlobalTool.LinuxToDate(Convert.ToDouble(strColumnValue)).ToString("dd-MMM-yyyy");
                //                    }
                //                }
                //                objT.Column_Value = strColumnValue;
                //            }
                //            //else if (objExtendedColumn.Is_Ref == "Y" && objExtendedColumn.Is_Multiple_Select == "N")
                //            //{
                //            //    foreach (var details in (List<ExtendedColumnDetails>)Metadata.Column_Value)
                //            //    {
                //            //        objT.Columns_Value_Code = details.ColumnValueId;
                //            //    }
                //            //}
                //            else if (objExtendedColumn.Is_Ref == "Y" && objExtendedColumn.Is_Multiple_Select == "Y")
                //            {
                //                foreach (var details in Metadata.metadata_values)
                //                {
                //                    Map_Extended_Columns_Details objMapExtendedColumnDetails = new Map_Extended_Columns_Details();
                //                    objMapExtendedColumnDetails.Columns_Value_Code = details.Columns_Value_Code;
                //                    objT.metadata_values.Add(objMapExtendedColumnDetails);
                //                }
                //            }

                //            objMap_Extended_ColumnsRepositories.Add(objT);

                //            MapExtendedData.Add(objT);
                //        }
                //    }

                //    foreach (var item in MapExtendedData.Where(x => x.EntityState == State.Deleted))
                //    {
                //        objMap_Extended_ColumnsRepositories.Delete(item);
                //    }

                //    var objMEC = MapExtendedData.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                //    objMEC.ForEach(i => MapExtendedData.Remove(i));


                //    foreach (var item in MapExtendedData.Where(x => x.EntityState != State.Deleted))
                //    {
                //        objMap_Extended_ColumnsRepositories.Update(item);
                //    }
                //}
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
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal objDealGeneral = new Acq_Deal();

                    objDealGeneral = objDealGeneralRepositories.GetById(id);

                    objDealGeneralRepositories.Delete(objDealGeneral);

                    _objRet.Response = new { id = objDealGeneral.Acq_Deal_Code };
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
