using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.InputClasses;
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

        public GenericReturn GetTitleList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
        {
            GenericReturn _objRet = new GenericReturn();
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

                    //for (int i = 0; i < _TitleReturn.assets.Count(); i++)
                    //{
                    //    List<USPAPI_Title_Bind_Extend_Data> lstExtended = new List<USPAPI_Title_Bind_Extend_Data>();
                    //    lstExtended = USPAPI_Title_Bind_Extend_Data(_TitleReturn.assets[i].Id);

                    //    if (lstExtended.Count() > 0)
                    //    {
                    //        var objGroupCode = lstExtended.Where(x => x.Extended_Group_Code != null).Select(x => x.Extended_Group_Code).Distinct().ToList();

                    //        foreach (Int32 item in objGroupCode)
                    //        {
                    //            string strGroupName = lstExtended.Where(x => x.Extended_Group_Code == item).Select(x => x.Group_Name).Distinct().FirstOrDefault();
                    //            Dictionary<string, string> objDictionary = new Dictionary<string, string>();
                    //            lstExtended.Where(x => x.Extended_Group_Code == item).ToList().ForEach(x =>
                    //            {
                    //                if (string.IsNullOrEmpty(x.Column_Value))
                    //                {
                    //                    objDictionary.Add(x.Columns_Name, x.Name);
                    //                }
                    //                else
                    //                {
                    //                    objDictionary.Add(x.Columns_Name, x.Column_Value);
                    //                }

                    //            });

                    //            _TitleReturn.assets[i].MetaData.Add(strGroupName, objDictionary);
                    //        }
                    //    }
                    //}
                }
            }
            catch (Exception ex)
            {
                //_objRet.Message = ex.Message;
                //_objRet.IsSuccess = false;
                //_objRet.StatusCode = HttpStatusCode.InternalServerError;
                //_objRet.Response = _TitleReturn;
                //return _objRet;
                throw;
            }

            _TitleReturn.paging.page = page;
            _TitleReturn.paging.size = size;

            _objRet.Response = _TitleReturn;

            return _objRet;
        }

        public List<USPAPI_Title_Bind_Extend_Data> USPAPI_Title_Bind_Extend_Data(Nullable<int> title_Code)
        {
            return objTitleRepositories.USPAPI_Title_Bind_Extend_Data(title_Code);
        }

        //public title GetById(Int32? id)
        //{
        //    title objTitleReturn = new title();
        //    objTitleReturn = objTitleRepositories.GetTitleById(id.Value);
        //    return objTitleReturn;
        //}

        public GenericReturn GetTitleById(Int32 id)
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

            title _TitleReturn = new title();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _TitleReturn = objTitleRepositories.GetTitleById(id);

                    if (_TitleReturn != null)
                    {
                        List<USPAPI_Title_Bind_Extend_Data> lstExtended = new List<USPAPI_Title_Bind_Extend_Data>();
                        lstExtended = USPAPI_Title_Bind_Extend_Data(_TitleReturn.id);

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
                //_objRet.Message = ex.Message;
                //_objRet.IsSuccess = false;
                //_objRet.StatusCode = HttpStatusCode.InternalServerError;
                //_objRet.Response = new title();// _TitleReturn;
                //return _objRet;
                throw;
            }

            _objRet.Response = _TitleReturn;

            return _objRet;
        }

        public GenericReturn PostTitle(TitleInput objInput)
        {

            //var T1 = objTitleRepositories.GetById(49138);

            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Name))
            {
                _objRet.Message = "Input Paramater 'Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            //if (objInput.DurationInMin <= 0)
            //{
            //    _objRet.Message = "Input Paramater 'DurationInMin' is mandatory";
            //    _objRet.IsSuccess = false;
            //    _objRet.StatusCode = HttpStatusCode.BadRequest;
            //    return _objRet;
            //}

            if (objInput.TitleLanguageId <= 0)
            {
                _objRet.Message = "Input Paramater 'TitleLanguageId' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                var Language = objTitleRepositories.Title_Validation(Convert.ToString(objInput.TitleLanguageId), "Language");

                if (Language.InputValueCode == 0)
                {
                    _objRet.Message = "Input Paramater 'TitleLanguageId :'" + Language.InvalidValue + " is not Valid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.Program > 0)
            {
                var Program = objTitleRepositories.Title_Validation(Convert.ToString(objInput.Program), "Program");

                if (Program.InputValueCode == 0)
                {
                    _objRet.Message = "Input Paramater 'Program :'" + Program.InvalidValue + " is not Valid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.Country.Count() > 0)
            {
                string strCountry = String.Join(",", objInput.Country.Select(x => x.CountryId.ToString()).ToArray());

                var Country = objTitleRepositories.Title_Validation(strCountry, "Country");

                if (Country.InputValueCode == 0)
                {
                    _objRet.Message = "Input Paramater 'Country :" + Country.InvalidValue + "' is not Valid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.TitleTalent.Count() > 0)
            {
                string strTitleTalent = String.Join(",", objInput.TitleTalent.Select(x => String.Format("{0}:{1}", x.TalentId.ToString(), x.RoleId.ToString())).ToArray());

                var talent = objTitleRepositories.Title_Validation(strTitleTalent, "talent");

                if (talent.InputValueCode == 0)
                {
                    _objRet.Message = "Input Paramater 'TitleTalent :" + talent.InvalidValue + "' is not Valid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.AssetTypeId <= 0)
            {
                _objRet.Message = "Input Paramater 'AssetTypeId' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else
            {
                var AssetType = objTitleRepositories.Title_Validation(Convert.ToString(objInput.AssetTypeId), "assettype");

                if (AssetType.InputValueCode == 0)
                {
                    _objRet.Message = "Input Paramater 'AssetTypeId :" + AssetType.InvalidValue + "' is not Valid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.TitleGenre.Count() > 0)
            {
                string strGenre = String.Join(",", objInput.TitleGenre.Select(x => x.GenreId.ToString()).ToArray());

                var Genres = objTitleRepositories.Title_Validation(strGenre, "Genres");

                if (Genres.InputValueCode == 0)
                {
                    _objRet.Message = "Input Paramater 'TitleGenre :" + Genres.InvalidValue + "' is not Valid";
                    _objRet.IsSuccess = false;
                    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    return _objRet;
                }
            }

            if (objInput.MetaData.Count() > 0)
            {
                for (int i = 0; i < objInput.MetaData.Count(); i++)
                {
                    string strMetadata = string.Empty;
                    string strExtendedType = string.Empty;

                    if (objInput.MetaData[i].Value.GetType() == typeof(List<ExtendedColumnDetails>))
                    {
                        var ExtendedObject = (List<ExtendedColumnDetails>)objInput.MetaData[i].Value;
                        strExtendedType = String.Join(",", ExtendedObject.Select(x => x.ColumnValueId.ToString()));

                        strMetadata = String.Join(":", objInput.MetaData[i].Key, strExtendedType);
                    }
                    else
                    {
                        //strExtendedType
                    }

                    var ExtendedGroup = objTitleRepositories.Title_Validation(Convert.ToString(objInput.MetaData.ElementAt(i).Key), "ExtendedGroup");

                    //if (ExtendedGroup.InputValueCode != "0")
                    //{
                    //    foreach (var EColumn in objInput.MetaData.ElementAt(i).Value)
                    //    {
                    //        var ExtendedColumns = objTitleRepositories.Title_Validation(ExtendedGroup.InputValueCode + "|" + EColumn.Key, "ExtendedColumns");

                    //        if (ExtendedColumns.InputValueCode != "0")
                    //        {
                    //            var ExtendedColumnValue = objTitleRepositories.Title_Validation(ExtendedColumns.InputValueCode + "|" + EColumn.Value, "ExtendedColumnValue");

                    //            if (ExtendedColumnValue.InputValueCode != "0" || ExtendedColumnValue.InputValueCode != "True")
                    //            {

                    //            }
                    //            else if (ExtendedColumnValue.InputValueCode == "0")
                    //            {
                    //                _objRet.Message = "Input Paramater 'MetaData : " + objInput.MetaData.ElementAt(i).Key + " : " + EColumn.Key + " : " + ExtendedColumnValue.InvalidValue + "' is not Valid";
                    //                _objRet.IsSuccess = false;
                    //                _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //                return _objRet;
                    //            }

                    //        }
                    //        else
                    //        {
                    //            _objRet.Message = "Input Paramater 'MetaData : " + objInput.MetaData.ElementAt(i).Key + " : " + ExtendedColumns.InvalidValue + "' is not Valid";
                    //            _objRet.IsSuccess = false;
                    //            _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //            return _objRet;
                    //        }

                    //    }
                    //}
                    //else
                    //{
                    //    _objRet.Message = "Input Paramater 'MetaData :" + ExtendedGroup.InvalidValue + "' is not Valid";
                    //    _objRet.IsSuccess = false;
                    //    _objRet.StatusCode = HttpStatusCode.BadRequest;
                    //    return _objRet;
                    //}
                }
            }

            #endregion


            return _objRet;
        }
    }
}
