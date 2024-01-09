using Newtonsoft.Json;
using RightsU.BMS.BLL.Miscellaneous;
using RightsU.BMS.DAL;
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
using System.Web;

namespace RightsU.BMS.BLL.Services
{
    public class TitleServices
    {
        private readonly TitleRepositories objTitleRepositories = new TitleRepositories();
        private readonly Title_CountryRepositories objTitle_CountryRepositories = new Title_CountryRepositories();
        private readonly Title_TalentRepositories objTitle_TalentRepositories = new Title_TalentRepositories();
        private readonly Title_GenersRepositories objTitle_GenersRepositories = new Title_GenersRepositories();
        private readonly Extended_ColumnsRepositories objExtendedColumnsRepositories = new Extended_ColumnsRepositories();
        private readonly Extended_Columns_ValueRepositories objExtended_Columns_ValueRepositories = new Extended_Columns_ValueRepositories();
        private readonly Map_Extended_ColumnsRepositories objMap_Extended_ColumnsRepositories = new Map_Extended_ColumnsRepositories();
        private readonly Map_Extended_Columns_DetailsRepositories objMap_Extended_Columns_DetailsRepositories = new Map_Extended_Columns_DetailsRepositories();
        private readonly LanguageRepositories objLanguageRepositories = new LanguageRepositories();
        private readonly ProgramRepositories objProgramRepositories = new ProgramRepositories();
        private readonly CountryRepositories objCountryRepositories = new CountryRepositories();
        private readonly TalentRepositories objTalentRepositories = new TalentRepositories();
        private readonly RoleRepositories objRoleRepositories = new RoleRepositories();
        private readonly Deal_TypeRepositories objDeal_TypeRepositories = new Deal_TypeRepositories();
        private readonly GenresRepositories objGenresRepositories = new GenresRepositories();
        private readonly BannerRepositories objBannerRepositories = new BannerRepositories();
        private readonly AL_LabRepositories objAL_LabRepositories = new AL_LabRepositories();
        private readonly VersionRepositories objVersionRepositories = new VersionRepositories();

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
                }
            }
            catch (Exception ex)
            {
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

            try
            {
                if (_objRet.IsSuccess)
                {
                    Title objTitle = new Title();

                    objTitle = objTitleRepositories.GetById(id);

                    var objMapExtended = objMap_Extended_ColumnsRepositories.SearchFor(new { Record_Code = objTitle.Title_Code });

                    if (objMapExtended.Count() > 0)
                    {
                        foreach (var item in objMapExtended)
                        {
                            if (item.extended_columns.Is_Ref == "N" && item.extended_columns.Is_Defined_Values == "N" && item.extended_columns.Is_Multiple_Select == "N")
                            {
                                string strColumnValue = string.Empty;

                                if (item.extended_columns.Control_Type == "DATE")
                                {
                                    if (!string.IsNullOrEmpty(item.Column_Value))
                                    {
                                        item.Column_Value = Convert.ToString(GlobalTool.DateToLinux(DateTime.Parse(item.Column_Value)));
                                    }
                                }
                            }
                            else if (item.extended_columns.Is_Ref == "Y" && item.extended_columns.Is_Multiple_Select == "N")
                            {
                                if (item.extended_columns.Is_Defined_Values == "Y")
                                {
                                    var objExtendedValue = objExtended_Columns_ValueRepositories.Get(item.Columns_Value_Code.Value);

                                    if (objExtendedValue != null)
                                    {
                                        item.Column_Value = objExtendedValue.Columns_Value;
                                    }
                                }
                                else
                                {
                                    if (item.extended_columns.Ref_Table.ToLower() == "Banner".ToLower())
                                    {
                                        var banner = objBannerRepositories.Get(item.Columns_Value_Code.Value);
                                        if (banner != null)
                                        {
                                            item.Column_Value = banner.Banner_Name;
                                        }
                                    }
                                    else if (item.extended_columns.Ref_Table.ToLower() == "Language".ToLower())
                                    {
                                        var language = objLanguageRepositories.Get(item.Columns_Value_Code.Value);
                                        if (language != null)
                                        {
                                            item.Column_Value = language.Language_Name;
                                        }
                                    }
                                    else if (item.extended_columns.Ref_Table.ToLower() == "Talent".ToLower())
                                    {
                                        var talent = objTalentRepositories.Get(item.Columns_Value_Code.Value);
                                        if (talent != null)
                                        {
                                            item.Column_Value = talent.Talent_Name;
                                        }
                                    }
                                    else if (item.extended_columns.Ref_Table.ToLower() == "version".ToLower())
                                    {
                                        var version = objVersionRepositories.Get(item.Columns_Value_Code.Value);
                                        if (version != null)
                                        {
                                            item.Column_Value = version.Version_Name;
                                        }
                                    }
                                    else if (item.extended_columns.Ref_Table.ToLower() == "AL_Lab".ToLower())
                                    {
                                        var alLab = objAL_LabRepositories.Get(item.Columns_Value_Code.Value);
                                        if (alLab != null)
                                        {
                                            item.Column_Value = alLab.AL_Lab_Name;
                                        }
                                    }
                                }
                            }
                            else if (item.extended_columns.Is_Ref == "Y" && item.extended_columns.Is_Multiple_Select == "Y")
                            {
                                if (item.extended_columns.Is_Defined_Values == "Y")
                                {
                                    item.metadata_values.ToList().ForEach(i =>
                                    {
                                        var objExtendedValue = objExtended_Columns_ValueRepositories.Get(i.Columns_Value_Code.Value);

                                        if (objExtendedValue != null)
                                        {
                                            i.name = objExtendedValue.Columns_Value;
                                        }

                                    });
                                }
                                else
                                {
                                    item.metadata_values.ToList().ForEach(i =>
                                    {
                                        if (item.extended_columns.Ref_Table.ToLower() == "Banner".ToLower())
                                        {
                                            var banner = objBannerRepositories.Get(i.Columns_Value_Code.Value);
                                            if (banner != null)
                                            {
                                                i.name = banner.Banner_Name;
                                            }
                                        }
                                        else if (item.extended_columns.Ref_Table.ToLower() == "Language".ToLower())
                                        {
                                            var language = objLanguageRepositories.Get(i.Columns_Value_Code.Value);
                                            if (language != null)
                                            {
                                                i.name = language.Language_Name;
                                            }
                                        }
                                        else if (item.extended_columns.Ref_Table.ToLower() == "Talent".ToLower())
                                        {
                                            var talent = objTalentRepositories.Get(i.Columns_Value_Code.Value);
                                            if (talent != null)
                                            {
                                                i.name = talent.Talent_Name;
                                            }
                                        }
                                        else if (item.extended_columns.Ref_Table.ToLower() == "version".ToLower())
                                        {
                                            var version = objVersionRepositories.Get(i.Columns_Value_Code.Value);
                                            if (version != null)
                                            {
                                                i.name = version.Version_Name;
                                            }
                                        }
                                        else if (item.extended_columns.Ref_Table.ToLower() == "AL_Lab".ToLower())
                                        {
                                            var alLab = objAL_LabRepositories.Get(i.Columns_Value_Code.Value);
                                            if (alLab != null)
                                            {
                                                i.name = alLab.AL_Lab_Name;
                                            }
                                        }
                                    });
                                }
                            }

                        }

                        objTitle.MetaData = objMapExtended.ToList();
                    }

                    _objRet.Response = objTitle;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }

        public GenericReturn PostTitle(Title objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Title_Name))
            {
                _objRet.Message = "Input Paramater 'title_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Title_Language_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'title_language_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            //else
            //{
            //    var Language = objTitleRepositories.Title_Validation(Convert.ToString(objInput.TitleLanguageId), "Language");

            //    if (Language.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'TitleLanguageId :'" + Language.InvalidValue + " is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            //if (objInput.Program > 0)
            //{
            //    var Program = objTitleRepositories.Title_Validation(Convert.ToString(objInput.Program), "Program");

            //    if (Program.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'Program :'" + Program.InvalidValue + " is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            //if (objInput.Country.Count() > 0)
            //{
            //    string strCountry = String.Join(",", objInput.Country.Select(x => x.CountryId.ToString()).ToArray());

            //    var Country = objTitleRepositories.Title_Validation(strCountry, "Country");

            //    if (Country.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'Country :" + Country.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            //if (objInput.TitleTalent.Count() > 0)
            //{
            //    string strTitleTalent = String.Join(",", objInput.TitleTalent.Select(x => String.Format("{0}:{1}", x.TalentId.ToString(), x.RoleId.ToString())).ToArray());

            //    var talent = objTitleRepositories.Title_Validation(strTitleTalent, "talent");

            //    if (talent.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'TitleTalent :" + talent.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            if (objInput.Deal_Type_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'deal_type_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            //else
            //{
            //    var AssetType = objTitleRepositories.Title_Validation(Convert.ToString(objInput.AssetTypeId), "assettype");

            //    if (AssetType.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'AssetTypeId :" + AssetType.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            //if (objInput.TitleGenre.Count() > 0)
            //{
            //    string strGenre = String.Join(",", objInput.TitleGenre.Select(x => x.GenreId.ToString()).ToArray());

            //    var Genres = objTitleRepositories.Title_Validation(strGenre, "Genres");

            //    if (Genres.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'TitleGenre :" + Genres.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            #endregion

            if (_objRet.IsSuccess)
            {
                objInput.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Inserted_On = DateTime.Now;
                objInput.Last_UpDated_Time = DateTime.Now;
                objInput.Is_Active = "Y";

                List<Title_Country> lstTitle_Country = new List<Title_Country>();
                foreach (var item in objInput.title_country)
                {
                    Title_Country objTitle_Country = new Title_Country();

                    objTitle_Country.Country_Code = item.Country_Code;
                    lstTitle_Country.Add(objTitle_Country);
                }
                objInput.title_country = lstTitle_Country;

                List<Title_Talent> lstTitle_Talent = new List<Title_Talent>();
                foreach (var item in objInput.title_talent)
                {
                    Title_Talent objTitle_Talent = new Title_Talent();
                    objTitle_Talent.Talent_Code = item.Talent_Code;
                    objTitle_Talent.Role_Code = item.Role_Code;
                    lstTitle_Talent.Add(objTitle_Talent);
                }
                objInput.title_talent = lstTitle_Talent;

                List<Title_Geners> lstTitle_Geners = new List<Title_Geners>();
                foreach (var item in objInput.title_genres)
                {
                    Title_Geners objTitleGeners = new Title_Geners();
                    objTitleGeners.Genres_Code = item.Genres_Code;
                    lstTitle_Geners.Add(objTitleGeners);
                }
                objInput.title_genres = lstTitle_Geners;

                objTitleRepositories.Add(objInput);

                _objRet.Response = new { id = objInput.Title_Code };

                if (objInput.Title_Code != null && objInput.Title_Code > 0)
                {
                    foreach (var Metadata in objInput.MetaData)
                    {
                        Metadata.extended_columns = objExtendedColumnsRepositories.Get(Metadata.extended_columns.columns_id.Value);

                        Metadata.Record_Code = objInput.Title_Code;
                        Metadata.Table_Name = "TITLE";
                        Metadata.Is_Multiple_Select = Metadata.extended_columns.Is_Multiple_Select;
                        Metadata.Row_No = Metadata.Row_No > 0 ? Metadata.Row_No : (int?)null;

                        if (Metadata.extended_columns.Is_Ref == "N" && Metadata.extended_columns.Is_Defined_Values == "N" && Metadata.extended_columns.Is_Multiple_Select == "N")
                        {
                            if (!string.IsNullOrEmpty(Convert.ToString(Metadata.Column_Value)))
                            {
                                if (Metadata.extended_columns.Control_Type == "DATE")
                                {
                                    Metadata.Column_Value = GlobalTool.LinuxToDate(Convert.ToDouble(Metadata.Column_Value)).ToString("dd-MMM-yyyy");
                                }
                            }
                        }
                        else if (Metadata.extended_columns.Is_Ref == "Y" && Metadata.extended_columns.Is_Multiple_Select == "Y")
                        {
                            List<Map_Extended_Columns_Details> lstMap_Extended_Columns_Details = new List<Map_Extended_Columns_Details>();

                            Metadata.metadata_values.ToList().ForEach(i =>
                            {
                                lstMap_Extended_Columns_Details.Add(new Map_Extended_Columns_Details()
                                {
                                    Columns_Value_Code = i.Columns_Value_Code.Value
                                });
                            });

                            Metadata.metadata_values = lstMap_Extended_Columns_Details;
                        }

                        objMap_Extended_ColumnsRepositories.Add(Metadata);
                    }
                }
            }

            return _objRet;
        }

        public GenericReturn PutTitle(Title objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Title_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'title_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Title_Name))
            {
                _objRet.Message = "Input Paramater 'title_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Title_Language_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'title_language_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (objInput.Deal_Type_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'deal_type_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }


            #endregion

            if (_objRet.IsSuccess)
            {               

                var objTitle = objTitleRepositories.GetById(objInput.Title_Code);

                objInput.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Last_UpDated_Time = DateTime.Now;
                objInput.Is_Active = "Y";

                #region Title_Country

                objTitle.title_country.ToList().ForEach(i => i.EntityState = State.Deleted);

                foreach (var item in objInput.title_country)
                {
                    Title_Country objT = (Title_Country)objTitle.title_country.Where(t => t.Country_Code == item.Country_Code).Select(i => i).FirstOrDefault();

                    if (objT == null)
                        objT = new Title_Country();
                    if (objT.Title_Country_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Code = objInput.Title_Code;
                        objT.Country_Code = item.Country_Code;
                        objTitle.title_country.Add(objT);
                    }
                }

                foreach (var item in objTitle.title_country.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objTitle_CountryRepositories.Delete(item);
                }

                var objCountry = objTitle.title_country.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                objCountry.ForEach(i => objTitle.title_country.Remove(i));

                objInput.title_country = objTitle.title_country;

                #endregion

                #region Title_Talent

                objTitle.title_talent.ToList().ForEach(i => i.EntityState = State.Deleted);

                foreach (var item in objInput.title_talent)
                {
                    Title_Talent objT = (Title_Talent)objTitle.title_talent.Where(t => t.Talent_Code == item.Talent_Code).Select(i => i).FirstOrDefault();

                    if (objT == null)
                        objT = new Title_Talent();
                    if (objT.Title_Talent_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Code = objInput.Title_Code;
                        objT.Talent_Code = item.Talent_Code;
                        objT.Role_Code = item.Role_Code;
                        objTitle.title_talent.Add(objT);
                    }
                }

                foreach (var item in objTitle.title_talent.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objTitle_TalentRepositories.Delete(item);
                }

                var objTalent = objTitle.title_talent.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                objTalent.ForEach(i => objTitle.title_talent.Remove(i));

                objInput.title_talent = objTitle.title_talent;

                #endregion

                #region Title_Geners

                objTitle.title_genres.ToList().ForEach(i => i.EntityState = State.Deleted);

                foreach (var item in objInput.title_genres)
                {
                    Title_Geners objT = (Title_Geners)objTitle.title_genres.Where(t => t.Genres_Code == item.Genres_Code).Select(i => i).FirstOrDefault();

                    if (objT == null)
                        objT = new Title_Geners();
                    if (objT.Title_Geners_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Title_Code = objInput.Title_Code;
                        objT.Genres_Code = item.Genres_Code;
                        objTitle.title_genres.Add(objT);
                    }
                }

                foreach (var item in objTitle.title_genres.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objTitle_GenersRepositories.Delete(item);
                }

                var objGeners = objTitle.title_genres.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                objGeners.ForEach(i => objTitle.title_genres.Remove(i));

                objInput.title_genres = objTitle.title_genres;

                #endregion

                objTitleRepositories.Update(objInput);

                _objRet.Response = new { id = objInput.Title_Code };

                if (objInput.Title_Code != null && objInput.Title_Code > 0)
                {
                    var MapExtendedData = objMap_Extended_ColumnsRepositories.SearchFor(new { Record_Code = objInput.Title_Code }).ToList();

                    MapExtendedData.ForEach(i => i.EntityState = State.Deleted);

                    foreach (var Metadata in objInput.MetaData)
                    {
                        Map_Extended_Columns objT = (Map_Extended_Columns)MapExtendedData.Where(t => t.Columns_Code == Metadata.Columns_Code && t.EntityState != State.Added && t.EntityState != State.Unchanged).Select(i => i).FirstOrDefault();

                        if (objT == null)
                            objT = new Map_Extended_Columns();
                        if (objT.Map_Extended_Columns_Code > 0)
                        {
                            objT.EntityState = State.Unchanged;

                            objT.Row_No = Metadata.Row_No > 0 ? Metadata.Row_No : (int?)null;

                            if (objT.extended_columns.Is_Ref == "N" && objT.extended_columns.Is_Defined_Values == "N" && objT.extended_columns.Is_Multiple_Select == "N")
                            {
                                string strColumnValue = string.Empty;

                                if (!string.IsNullOrEmpty(Convert.ToString(Metadata.Column_Value)))
                                {
                                    strColumnValue = Convert.ToString(Metadata.Column_Value);

                                    if (objT.extended_columns.Control_Type == "DATE")
                                    {
                                        strColumnValue = GlobalTool.LinuxToDate(Convert.ToDouble(strColumnValue)).ToString("dd-MMM-yyyy");
                                    }
                                }
                                objT.Column_Value = strColumnValue;
                            }
                            else if (objT.extended_columns.Is_Ref == "Y" && objT.extended_columns.Is_Multiple_Select == "N")
                            {
                                objT.Columns_Value_Code = Metadata.Columns_Value_Code;                                
                            }
                            else if (objT.extended_columns.Is_Ref == "Y" && objT.extended_columns.Is_Multiple_Select == "Y")
                            {
                                objT.metadata_values.ToList().ForEach(i => i.EntityState = State.Deleted);

                                foreach (var details in Metadata.metadata_values)
                                {
                                    Map_Extended_Columns_Details objMECD = (Map_Extended_Columns_Details)objT.metadata_values.Where(t => t.Columns_Value_Code == details.Columns_Value_Code).Select(i => i).FirstOrDefault();

                                    if (objMECD == null)
                                        objMECD = new Map_Extended_Columns_Details();
                                    if (objMECD.Map_Extended_Columns_Details_Code > 0)
                                        objMECD.EntityState = State.Unchanged;
                                    else
                                    {
                                        objT.EntityState = State.Added;
                                        objMECD.Columns_Value_Code = details.Columns_Value_Code;
                                        objMECD.Map_Extended_Columns_Code = objT.Map_Extended_Columns_Code;

                                        objT.metadata_values.Add(objMECD);
                                    }
                                }

                                foreach (var item in objT.metadata_values.ToList().Where(x => x.EntityState == State.Deleted))
                                {
                                    objMap_Extended_Columns_DetailsRepositories.Delete(item);
                                }

                                var objdetails = objT.metadata_values.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                                foreach (var deleted in objdetails)
                                {
                                    objT.metadata_values.Remove(deleted);
                                }
                            }
                        }
                        else
                        {
                            var objExtendedColumn = objExtendedColumnsRepositories.Get(Metadata.Columns_Code.Value);

                            objT.EntityState = State.Added;
                            objT.Record_Code = objInput.Title_Code;
                            objT.Table_Name = "TITLE";
                            objT.extended_columns = objExtendedColumn;
                            objT.Is_Multiple_Select = objExtendedColumn.Is_Multiple_Select;
                            objT.Row_No = Metadata.Row_No > 0 ? Metadata.Row_No : (int?)null;

                            if (objExtendedColumn.Is_Ref == "N" && objExtendedColumn.Is_Defined_Values == "N" && objExtendedColumn.Is_Multiple_Select == "N")
                            {
                                string strColumnValue = string.Empty;

                                if (!string.IsNullOrEmpty(Convert.ToString(Metadata.Column_Value)))
                                {
                                    strColumnValue = Convert.ToString(Metadata.Column_Value);

                                    if (objExtendedColumn.Control_Type == "DATE")
                                    {
                                        strColumnValue = GlobalTool.LinuxToDate(Convert.ToDouble(strColumnValue)).ToString("dd-MMM-yyyy");
                                    }
                                }
                                objT.Column_Value = strColumnValue;
                            }
                            //else if (objExtendedColumn.Is_Ref == "Y" && objExtendedColumn.Is_Multiple_Select == "N")
                            //{
                            //    foreach (var details in (List<ExtendedColumnDetails>)Metadata.Column_Value)
                            //    {
                            //        objT.Columns_Value_Code = details.ColumnValueId;
                            //    }
                            //}
                            else if (objExtendedColumn.Is_Ref == "Y" && objExtendedColumn.Is_Multiple_Select == "Y")
                            {
                                foreach (var details in Metadata.metadata_values)
                                {
                                    Map_Extended_Columns_Details objMapExtendedColumnDetails = new Map_Extended_Columns_Details();
                                    objMapExtendedColumnDetails.Columns_Value_Code = details.Columns_Value_Code;
                                    objT.metadata_values.Add(objMapExtendedColumnDetails);
                                }
                            }

                            objMap_Extended_ColumnsRepositories.Add(objT);

                            MapExtendedData.Add(objT);
                        }
                    }

                    foreach (var item in MapExtendedData.Where(x => x.EntityState == State.Deleted))
                    {
                        objMap_Extended_ColumnsRepositories.Delete(item);
                    }

                    var objMEC = MapExtendedData.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objMEC.ForEach(i => MapExtendedData.Remove(i));


                    foreach (var item in MapExtendedData.Where(x => x.EntityState != State.Deleted))
                    {
                        objMap_Extended_ColumnsRepositories.Update(item);
                    }
                }
            }

            return _objRet;
        }

        public GenericReturn ChangeActiveStatus(PutInput objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.id <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Status))
            {
                _objRet.Message = "Input Paramater 'Status' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Status.ToUpper() != "Y" && objInput.Status.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'Status' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Title objTitle = new Title();

                objTitle = objTitleRepositories.GetById(objInput.id);

                objTitle.Last_UpDated_Time = DateTime.Now;
                objTitle.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objTitle.Is_Active = objInput.Status.ToUpper();

                objTitleRepositories.Update(objTitle);
                _objRet.Response = new { id = objTitle.Title_Code };

            }

            return _objRet;
        }
    }
}
