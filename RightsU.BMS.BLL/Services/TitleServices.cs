using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.BLL.Services
{
    public class TitleServices
    {
        private readonly TitleRepositories objTitleRepositories = new TitleRepositories();
        //public TitleReturn List_Titles(string order, Int32? page, string search_value, Int32? size, string sort, string Date_GT, string Date_LT, Int32? id)
        //{
        //    TitleReturn objTitleReturn = new TitleReturn();
        //    objTitleReturn = objTitleRepositories.GetTitle_List(order, page.Value, search_value, size.Value, sort, Date_GT, Date_LT, id.Value);
        //    return objTitleReturn;
        //}

        public GetReturn GetTitleList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
        {
            GetReturn _objRet = new GetReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validations

            if (!string.IsNullOrEmpty(order))
            {
                if (order.ToUpper() != "ASC")
                {
                    if (order.ToUpper() != "DESC")
                    {
                        _objRet.Message = "Input Paramater 'order' is not in valid format";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
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
                    _objRet.Message = "Input Paramater 'size' should not be greater than " + maxSize;
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                }
            }
            else
            {
                size = Convert.ToInt32(ConfigurationManager.AppSettings["defaultSize"]);
            }

            if (!string.IsNullOrEmpty(sort.ToString()))
            {
                if (sort.ToLower() == "CreatedDate".ToLower())
                {
                    sort = "Inserted_On";
                }
                else if (sort.ToLower() == "UpdatedDate".ToLower())
                {
                    sort = "Last_UpDated_Time";
                }
                else if (sort.ToLower() == "TitleName".ToLower())
                {
                    sort = "Title_Name";
                }
                else
                {
                    _objRet.Message = "Input Paramater 'sort' is not in valid format";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                }
            }
            else
            {
                sort = ConfigurationManager.AppSettings["defaultSort"];
            }

            try
            {
                if (!string.IsNullOrEmpty(Date_GT))
                {
                    try
                    {
                        Date_GT = DateTime.Parse(Date_GT).ToString("yyyy-MM-dd");
                    }
                    catch (Exception ex)
                    {
                        _objRet.Message = "Input Paramater 'dateGt' is not in valid format";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }

                }
                if (!string.IsNullOrEmpty(Date_LT))
                {
                    try
                    {
                        Date_LT = DateTime.Parse(Date_LT).ToString("yyyy-MM-dd");
                    }
                    catch (Exception ex)
                    {
                        _objRet.Message = "Input Paramater 'dateLt' is not in valid format";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }

                if (!string.IsNullOrEmpty(Date_GT) && !string.IsNullOrEmpty(Date_LT))
                {
                    if (DateTime.Parse(Date_GT) > DateTime.Parse(Date_LT))
                    {
                        _objRet.Message = "Input Paramater 'dateLt' should not be less than 'dateGt'";
                        _objRet.IsSuccess = false;
                        _objRet.StatusCode = HttpStatusCode.BadRequest;
                    }
                }
            }
            catch (Exception ex)
            {
                _objRet.Message = "Input Paramater 'dateLt' or 'dateGt' is not in valid format";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            TitleReturn _TitleReturn = new TitleReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _TitleReturn = objTitleRepositories.GetTitle_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);

                    for (int i = 0; i < _TitleReturn.assets.Count(); i++)
                    {
                        List<USP_Bind_Extend_Column_Grid_Result> lstExtended = new List<USP_Bind_Extend_Column_Grid_Result>();
                        lstExtended = USP_Bind_Extend_Column_Grid(_TitleReturn.assets[i].Id);

                        if (lstExtended.Count() > 0)
                        {
                            var objGroupCode = lstExtended.Where(x => x.Extended_Group_Code != null).Select(x => x.Extended_Group_Code).Distinct().ToList();

                            foreach (Int32 item in objGroupCode)
                            {
                                string strGroupName = lstExtended.Where(x => x.Extended_Group_Code == item).Select(x => x.Group_Name).Distinct().FirstOrDefault();
                                Dictionary<string, string> objDictionary = new Dictionary<string, string>();
                                lstExtended.Where(x => x.Extended_Group_Code == item).ToList().ForEach(x =>
                                {
                                    if (string.IsNullOrEmpty(x.Column_Value))
                                    {
                                        objDictionary.Add(x.Columns_Name, x.Name);
                                    }
                                    else
                                    {
                                        objDictionary.Add(x.Columns_Name, x.Column_Value);
                                    }

                                });

                                _TitleReturn.assets[i].MetaData.Add(strGroupName, objDictionary);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.InternalServerError;
                _objRet.AssetResponse = _TitleReturn;
                return _objRet;
            }

            _TitleReturn.paging.page = page;
            _TitleReturn.paging.size = size;

            _objRet.AssetResponse = _TitleReturn;

            return _objRet;
        }

        public List<USP_Bind_Extend_Column_Grid_Result> USP_Bind_Extend_Column_Grid(Nullable<int> title_Code)
        {

            return objTitleRepositories.USP_Bind_Extend_Column_Grid(title_Code);
        }

        //public title GetById(Int32? id)
        //{
        //    title objTitleReturn = new title();
        //    objTitleReturn = objTitleRepositories.GetTitleById(id.Value);
        //    return objTitleReturn;
        //}

        public GetTitleReturn GetTitleById(Int32 id)
        {
            GetTitleReturn _objRet = new GetTitleReturn();
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

            title _TitleReturn = new title();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _TitleReturn = objTitleRepositories.GetTitleById(id);

                    if (_TitleReturn != null)
                    {
                        List<USP_Bind_Extend_Column_Grid_Result> lstExtended = new List<USP_Bind_Extend_Column_Grid_Result>();
                        lstExtended = USP_Bind_Extend_Column_Grid(_TitleReturn.Id);

                        if (lstExtended.Count() > 0)
                        {
                            var objGroupCode = lstExtended.Select(x => x.Extended_Group_Code).Distinct().ToList();

                            foreach (Int32 item in objGroupCode)
                            {
                                string strGroupName = lstExtended.Where(x => x.Extended_Group_Code == item).Select(x => x.Group_Name).Distinct().FirstOrDefault();
                                Dictionary<string, string> objDictionary = new Dictionary<string, string>();
                                lstExtended.Where(x => x.Extended_Group_Code == item).ToList().ForEach(x =>
                                {
                                    if (string.IsNullOrEmpty(x.Column_Value))
                                    {
                                        objDictionary.Add(x.Columns_Name, x.Name);
                                    }
                                    else
                                    {
                                        objDictionary.Add(x.Columns_Name, x.Column_Value);
                                    }

                                });

                                _TitleReturn.MetaData.Add(strGroupName, objDictionary);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.InternalServerError;
                _objRet.AssetResponse = _TitleReturn;
                return _objRet;
            }

            _objRet.AssetResponse = _TitleReturn;

            return _objRet;
        }
    }
}
