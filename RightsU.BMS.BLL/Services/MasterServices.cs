
using RightsU.BMS.DAL;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.Master_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using RightsU.BMS.DAL.Repository;
using RightsU.BMS.Entities.FrameworkClasses;
using System.Net;
using System.Configuration;
using System.Web;

namespace RightsU.BMS.BLL.Services
{
    public class UserServices
    {
        private readonly UserRepositories objUserRepository;

        public UserServices()
        {
            this.objUserRepository = new UserRepositories();
        }

        public User GetUserByID(int ID)
        {
            return objUserRepository.Get(ID);
        }

        public IEnumerable<User> GetUserList()
        {
            return objUserRepository.GetAll();
        }
        public void UpdateUser(User obj)
        {
            objUserRepository.Update(obj);
        }

        public IEnumerable<User> SearchForUser(object param)
        {
            return objUserRepository.SearchFor(param);
        }

        public IEnumerable<User> GetDataWithSQLStmt(string strSQL)
        {

            return objUserRepository.GetDataWithSQLStmt(strSQL);
        }


    }
    public class SystemParameterServices
    {
        private readonly SystemParametersRepositories objSystemParametersRepositories;
        public SystemParameterServices()
        {
            this.objSystemParametersRepositories = new SystemParametersRepositories();
        }
        public IEnumerable<System_Parameter_New> GetSystemParameterList()
        {
            return objSystemParametersRepositories.GetAll();
        }
        public IEnumerable<System_Parameter_New> SearchFor(object param)
        {
            return objSystemParametersRepositories.SearchFor(param);
        }
    }

    public class BMS_Log_Service
    {
        private readonly BMS_Log_Repositories objBMSLogRepositories;
        public BMS_Log_Service()
        {
            this.objBMSLogRepositories = new BMS_Log_Repositories();
        }
        public IEnumerable<BMS_Log> GetBMS_LogList()
        {
            return objBMSLogRepositories.GetAll();
        }
        public IEnumerable<BMS_Log> SearchFor(object param)
        {
            return objBMSLogRepositories.SearchFor(param);
        }
        public int InsertLog(BMS_Log param)
        {
            return objBMSLogRepositories.InsertBMSLog(param);
        }
    }

    public class Channel_Service
    {
        private readonly Channel_Repositories objChannelRepositories;
        public Channel_Service()
        {
            this.objChannelRepositories = new Channel_Repositories();
        }
        public IEnumerable<Channel> GetChannelList()
        {
            return objChannelRepositories.GetAll();
        }
        public IEnumerable<Channel> SearchFor(object param)
        {
            return objChannelRepositories.SearchFor(param);
        }
    }

    public class BMS_Schedule_Import_Config_Service
    {
        private readonly BMS_Schedule_Import_Config_Repositories objBMSScheduleImportConfigRepositories;
        public BMS_Schedule_Import_Config_Service()
        {
            this.objBMSScheduleImportConfigRepositories = new BMS_Schedule_Import_Config_Repositories();
        }
        public IEnumerable<BMS_Schedule_Import_Config> GetChannelList()
        {
            return objBMSScheduleImportConfigRepositories.GetAll();
        }
        public IEnumerable<BMS_Schedule_Import_Config> SearchFor(object param)
        {
            return objBMSScheduleImportConfigRepositories.SearchFor(param);
        }
    }

    public class Upload_Files_Service
    {
        private readonly Upload_Files_Repositories objUploadFilesRepositories;
        public Upload_Files_Service()
        {
            this.objUploadFilesRepositories = new Upload_Files_Repositories();
        }
        public void Upload_Files_Save(Upload_Files objUploadFiles)
        {
            this.objUploadFilesRepositories.Add(objUploadFiles);
        }
    }

    public class ServiceLogServices
    {
        private readonly ServiceLogRepositories objServiceLogRepositories = new ServiceLogRepositories();

        public ServiceLogServices()
        {
            this.objServiceLogRepositories = new ServiceLogRepositories();
        }

        public int AddEntity(ServiceLog param)
        {
            objServiceLogRepositories.Add(param);
            return param.ServiceLogID.Value;
        }

        public void UpdateServiceLog(ServiceLog obj)
        {
            objServiceLogRepositories.Update(obj);
        }
    }

    public class LoggedInUsersServices
    {
        private readonly LoggedInUsersRepository objLoggedInUsersRepository;

        public LoggedInUsersServices()
        {
            this.objLoggedInUsersRepository = new LoggedInUsersRepository();
        }
        public LoggedInUsers GetLoggedInUserByID(int ID)
        {
            return objLoggedInUsersRepository.Get(ID);
        }
        public IEnumerable<LoggedInUsers> GetLoggedInUsersList()
        {
            return objLoggedInUsersRepository.GetAll();
        }
        public void AddEntity(LoggedInUsers param)
        {
            objLoggedInUsersRepository.Add(param);
        }
        public void UpdateLoggedInUser(LoggedInUsers obj)
        {
            objLoggedInUsersRepository.Update(obj);
        }
        public void DeleteLoggedInUsers(LoggedInUsers obj)
        {
            objLoggedInUsersRepository.Delete(obj);
        }

        public IEnumerable<LoggedInUsers> SearchFor(object param)
        {
            return objLoggedInUsersRepository.SearchFor(param);
        }
    }

    public class System_Module_Service
    {
        private readonly System_Module_Repositories objSystemModuleRepositories;
        public System_Module_Service()
        {
            this.objSystemModuleRepositories = new System_Module_Repositories();
        }
        public IEnumerable<System_Module> GetAll()
        {
            return objSystemModuleRepositories.GetAll();
        }
        public IEnumerable<System_Module> SearchFor(object param)
        {
            return objSystemModuleRepositories.SearchFor(param);
        }
        public List<System_Module> USP_GetModule(Int32 Security_Group_Code, Int32 Users_Code)
        {
            return objSystemModuleRepositories.USP_GetModule(Security_Group_Code, Users_Code);
        }

        public List<USPAPI_GetModuleRights> USPAPI_GetModuleRights(Int32 Security_Group_Code)
        {
            return objSystemModuleRepositories.USPAPI_GetModuleRights(Security_Group_Code);
        }

        public int hasModuleRights(string Module_Url, string Rights_Name, string authenticationToken, string RefreshToken)
        {
            int hasRights = 0;

            LoggedInUsersServices objLoggedInUsersServices = new LoggedInUsersServices();
            UserServices objUserServices = new UserServices();

            LoggedInUsers objUserDetails = objLoggedInUsersServices.SearchFor(new { AccessToken = authenticationToken, RefreshToken = RefreshToken }).ToList().FirstOrDefault();

            if (objUserDetails != null)
            {
                User objUser = new User();
                objUser = objUserServices.SearchForUser(new { Login_Name = objUserDetails.LoginName }).FirstOrDefault();

                var UserModuleRights = USPAPI_GetModuleRights(objUser.Security_Group_Code.Value);

                var lstModuleUrl = Module_Url.Split(new[] { '/' }, StringSplitOptions.RemoveEmptyEntries);

                var objModuleRights = UserModuleRights.Where(x => x.Module_Name.ToLower() == lstModuleUrl[1].ToLower()).ToList();

                if (objModuleRights.Count() > 0)
                {
                    if (lstModuleUrl.Count() > 2)
                    {
                        if (Rights_Name.ToLower() == "get" && objModuleRights.Any(x => x.Right_Name.ToLower() == Rights_Name.ToLower()))
                        {
                            hasRights = objUser.Users_Code.Value;
                        }
                        else if (objModuleRights.Any(x => x.Right_Name.ToLower() == lstModuleUrl[2].ToLower()))
                        {
                            hasRights = objUser.Users_Code.Value;
                        }
                        else
                        {
                            hasRights = 0;
                        }
                    }
                    else if (objModuleRights.Any(x => x.Right_Name == Rights_Name))
                    {
                        hasRights = objUser.Users_Code.Value;
                    }
                    else
                    {
                        hasRights = 0;
                    }
                }
                else
                {
                    hasRights = 0;
                }

                //if (UserModuleRights.Where(x => x.Module_Code == Module_Code).ToList().Count() > 0)
                //{
                //    hasRights = true;
                //}
                //else
                //{
                //    hasRights = false;
                //}
            }

            return hasRights;
        }
    }

    public class RoleService
    {
        private readonly RoleRepositories objRoleRepositories = new RoleRepositories();

        public GenericReturn GetRoleList(string order, string sort, Int32 size, Int32 page, string search_value, Int32? id)
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
                if (sort.ToLower() == "RoleName".ToLower())
                {
                    sort = "Role_Name";
                }
            }
            else
            {
                sort = ConfigurationManager.AppSettings["defaultSort"];
            }
            #endregion

            RoleReturn _RoleReturn = new RoleReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _RoleReturn = objRoleRepositories.GetRole_List(order, page, search_value, size, sort, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            _RoleReturn.paging.page = page;
            _RoleReturn.paging.size = size;
            _objRet.Response = _RoleReturn;
            return _objRet;
        }
    }

    public class DealTypeService
    {
        private readonly DealTypeRepositories objDealTypeRepositories = new DealTypeRepositories();

        public GenericReturn GetDealTypeList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                    sort = "Last_Updated_Time";
                }
                else if (sort.ToLower() == "DealTypeName".ToLower())
                {
                    sort = "Deal_Type_Name";
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

            Deal_TypeReturn _DealTypeReturn = new Deal_TypeReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _DealTypeReturn = objDealTypeRepositories.GetDealType_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _DealTypeReturn.paging.page = page;
            _DealTypeReturn.paging.size = size;

            _objRet.Response = _DealTypeReturn;

            return _objRet;
        }
    }

    public class ChannelCategoryService
    {
        private readonly ChannelCategoryRepositories objChannelCategoryRepositories = new ChannelCategoryRepositories();

        public GenericReturn GetChannelCategoryList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                    sort = "Last_Updated_Time";
                }
                else if (sort.ToLower() == "ChannelCategoryName".ToLower())
                {
                    sort = "Channel_Category_Name";
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

            Channel_CategoryReturn _ChannelCategoryReturn = new Channel_CategoryReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _ChannelCategoryReturn = objChannelCategoryRepositories.GetChannelCategory_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _ChannelCategoryReturn.paging.page = page;
            _ChannelCategoryReturn.paging.size = size;

            _objRet.Response = _ChannelCategoryReturn;

            return _objRet;
        }
    }

    public class PlatformService
    {
        private readonly PlatformRepositories objPlatformRepositories = new PlatformRepositories();

        public GenericReturn GetPlatformList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                    sort = "Last_Updated_Time";
                }
                else if (sort.ToLower() == "ChannelCategoryName".ToLower())
                {
                    sort = "Platform_Name";
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

            PlatformReturn _PlatformReturn = new PlatformReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _PlatformReturn = objPlatformRepositories.GetPlatform_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _PlatformReturn.paging.page = page;
            _PlatformReturn.paging.size = size;

            _objRet.Response = _PlatformReturn;

            return _objRet;
        }
    }

    #region Genres
    public class GenreServices
    {
        private readonly GenresRepositories objGenreRepositories = new GenresRepositories();
        public GenericReturn GetGenreList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                else if (sort.ToLower() == "GenreName".ToLower())
                {
                    sort = "Genres_Name";
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

            GenreReturn _GenreReturn = new GenreReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _GenreReturn = objGenreRepositories.GetGenre_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _GenreReturn.paging.page = page;
            _GenreReturn.paging.size = size;

            _objRet.Response = _GenreReturn;

            return _objRet;
        }
        public GenericReturn GetGenreById(Int32 id)
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
                    Genres objGenre = new Genres();

                    objGenre = objGenreRepositories.GetById(id);

                    _objRet.Response = objGenre;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }
        public GenericReturn PostGenre(Genres objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Genres_Name))
            {
                _objRet.Message = "Input Paramater 'genre_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objGenreRepositories.SearchFor(new { Genres_Name = objInput.Genres_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'genre_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Genres objGenre = new Genres();

                objGenre.Genres_Name = objInput.Genres_Name;
                objGenre.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objGenre.Inserted_On = DateTime.Now;
                objGenre.Last_Updated_Time = DateTime.Now;
                objGenre.Is_Active = "Y";

                objGenreRepositories.Add(objGenre);
                _objRet.Response = new { id = objGenre.Genres_Code };

            }

            return _objRet;
        }
        public GenericReturn PutGenre(Genres objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Genres_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'genres_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Genres_Name))
            {
                _objRet.Message = "Input Paramater 'genre_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objGenreRepositories.SearchFor(new { Genres_Name = objInput.Genres_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'genre_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            #endregion

            if (_objRet.IsSuccess)
            {
                Genres objGenre = new Genres();

                objGenre = objGenreRepositories.Get(objInput.Genres_Code.Value);

                objGenre.Genres_Name = objInput.Genres_Name;
                objGenre.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objGenre.Last_Updated_Time = DateTime.Now;
                //objGenre.Is_Active = "Y";

                objGenreRepositories.AddEntity(objGenre);

                _objRet.Response = new { id = objGenre.Genres_Code };
            }

            return _objRet;
        }
        public GenericReturn ChangeActiveStatus(Genres objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Genres_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'genres_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Genres objGenre = new Genres();

                objGenre = objGenreRepositories.Get(objInput.Genres_Code.Value);

                objGenre.Last_Updated_Time = DateTime.Now;
                objGenre.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objGenre.Is_Active = objInput.Is_Active.ToUpper();

                objGenreRepositories.Update(objGenre);
                _objRet.Response = new { id = objGenre.Genres_Code };

            }

            return _objRet;
        }
    }
    #endregion

    #region Program
    public class ProgramServices
    {
        private readonly ProgramRepositories objProgramRepositories = new ProgramRepositories();

        public GenericReturn GetProgramList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                else if (sort.ToLower() == "ProgramName".ToLower())
                {
                    sort = "Program_Name";
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

            ProgramReturn _ProgramReturn = new ProgramReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _ProgramReturn = objProgramRepositories.GetProgram_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _ProgramReturn.paging.page = page;
            _ProgramReturn.paging.size = size;

            _objRet.Response = _ProgramReturn;

            return _objRet;
        }
        public GenericReturn GetProgramById(Int32 id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (id == 0)
            {
                _objRet.Message = "Input Paramater 'program_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Program objGenre = new Program();

                    objGenre = objProgramRepositories.GetById(id);

                    _objRet.Response = objGenre;
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return _objRet;
        }
        public GenericReturn PostProgram(Program objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Program_Name))
            {
                _objRet.Message = "Input Paramater 'program_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objProgramRepositories.SearchFor(new { Program_Name = objInput.Program_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'program_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Program objProgram = new Program();

                objProgram.Program_Name = objInput.Program_Name;
                objProgram.Deal_Type_Code = objInput.Deal_Type_Code;
                objProgram.Genres_Code = objInput.Genres_Code;
                objProgram.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objProgram.Inserted_On = DateTime.Now;
                objProgram.Last_UpDated_Time = DateTime.Now;
                objProgram.Is_Active = "Y";

                objProgramRepositories.Add(objProgram);

                _objRet.Response = new { id = objProgram.Program_Code };

            }

            return _objRet;
        }
        public GenericReturn PutProgram(Program objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Program_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'program_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Program_Name))
            {
                _objRet.Message = "Input Paramater 'program_name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            var CheckDuplicate = objProgramRepositories.SearchFor(new { Program_Name = objInput.Program_Name }).ToList();

            if (CheckDuplicate.Count > 0)
            {
                _objRet.Message = "'program_name' already exists.";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Program objProgram = new Program();

                objProgram = objProgramRepositories.Get(objInput.Program_Code.Value);

                objProgram.Program_Name = objInput.Program_Name;
                objProgram.Deal_Type_Code = objInput.Deal_Type_Code;
                objProgram.Genres_Code = objInput.Genres_Code;
                objProgram.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objProgram.Last_UpDated_Time = DateTime.Now;
                //objProgram.Is_Active = "Y";

                objProgramRepositories.AddEntity(objProgram);

                _objRet.Response = new { id = objProgram.Program_Code };
            }

            return _objRet;
        }
        public GenericReturn ChangeActiveStatus(Program objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Program_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'program_id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'is_active' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'is_active' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Program objProgram = new Program();

                objProgram = objProgramRepositories.Get(objInput.Program_Code.Value);

                objProgram.Last_UpDated_Time = DateTime.Now;
                objProgram.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objProgram.Is_Active = objInput.Is_Active.ToUpper();

                objProgramRepositories.Update(objProgram);
                _objRet.Response = new { id = objProgram.Program_Code };

            }

            return _objRet;
        }
    }
    #endregion

    #region Talent
    public class TalentServices
    {
        private readonly TalentRepositories objTalentRepositories = new TalentRepositories();
        private readonly Talent_RoleRepositories objTalent_RoleRepositories = new Talent_RoleRepositories();

        public GenericReturn GetTalentList(string order, string sort, Int32 size, Int32 page, string search_value, string Date_GT, string Date_LT, Int32? id)
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
                else if (sort.ToLower() == "TalentName".ToLower())
                {
                    sort = "Talent_Name";
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

            TalentReturn _TalentReturn = new TalentReturn();

            try
            {
                if (_objRet.IsSuccess)
                {
                    _TalentReturn = objTalentRepositories.GetTalent_List(order, page, search_value, size, sort, Date_GT, Date_LT, id.Value);
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            _TalentReturn.paging.page = page;
            _TalentReturn.paging.size = size;

            _objRet.Response = _TalentReturn;

            return _objRet;
        }
        public GenericReturn PostTalent(Talent objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (string.IsNullOrEmpty(objInput.Talent_Name))
            {
                _objRet.Message = "Input Paramater 'Talent Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            //if (objInput.Talent_Role.Count() > 0)
            //{
            //    string strRole = String.Join(",", objInput.Talent_Role.Select(x => x.Role_Code.ToString()).ToArray());

            //    var Role = objTalentRepositories.Talent_Validation(strRole, "Role");

            //    if (Role.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'Role :" + Role.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            #endregion

            if (_objRet.IsSuccess)
            {
                Talent objTalent = new Talent();

                objTalent.Talent_Name = objInput.Talent_Name;
                objTalent.Gender = objInput.Gender;
                objTalent.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objTalent.Inserted_On = DateTime.Now;
                objTalent.Last_Updated_Time = DateTime.Now;
                objTalent.Is_Active = "Y";

                foreach (var item in objInput.Talent_Role)
                {
                    Talent_Role objTalent_Role = new Talent_Role();
                    objTalent_Role.Role_Code = item.Role_Code;
                    objTalent.Talent_Role.Add(objTalent_Role);
                }

                objTalentRepositories.Add(objTalent);
                _objRet.Response = new { id = objTalent.Talent_Code };
            }

            return _objRet;
        }
        public GenericReturn PutTalent(Talent objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Talent_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Talent_Name))
            {
                _objRet.Message = "Input Paramater 'Talent Name' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            //if (objInput.Talent_Role.Count() > 0)
            //{
            //    string strRole = String.Join(",", objInput.Talent_Role.Select(x => x.Role_Code.ToString()).ToArray());

            //    var Role = objTalentRepositories.Talent_Validation(strRole, "Role");

            //    if (Role.InputValueCode == 0)
            //    {
            //        _objRet.Message = "Input Paramater 'Role :" + Role.InvalidValue + "' is not Valid";
            //        _objRet.IsSuccess = false;
            //        _objRet.StatusCode = HttpStatusCode.BadRequest;
            //        return _objRet;
            //    }
            //}

            #endregion

            if (_objRet.IsSuccess)
            {
                Talent objTalent = new Talent();

                objTalent = objTalentRepositories.Get(objInput.Talent_Code.Value);

                objTalent.Talent_Name = objInput.Talent_Name;
                objTalent.Gender = objInput.Gender;
                objTalent.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objTalent.Last_Updated_Time = DateTime.Now;
                objTalent.Is_Active = "Y";

                #region Talent_Role

                objTalent.Talent_Role.ToList().ForEach(i => i.EntityState = State.Deleted);

                foreach (var item in objInput.Talent_Role)
                {
                    Talent_Role objT = (Talent_Role)objTalent.Talent_Role.Where(t => t.Role_Code == item.Role_Code).Select(i => i).FirstOrDefault();

                    if (objT == null)
                        objT = new Talent_Role();
                    if (objT.Talent_Role_Code > 0)
                        objT.EntityState = State.Unchanged;
                    else
                    {
                        objT.EntityState = State.Added;
                        objT.Talent_Code = objInput.Talent_Code;
                        objT.Role_Code = item.Role_Code;
                        objTalent.Talent_Role.Add(objT);
                    }
                }

                foreach (var item in objTalent.Talent_Role.ToList().Where(x => x.EntityState == State.Deleted))
                {
                    objTalent_RoleRepositories.Delete(item);
                }

                var objRole = objTalent.Talent_Role.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                objRole.ForEach(i => objTalent.Talent_Role.Remove(i));

                #endregion


                objTalentRepositories.AddEntity(objTalent);

                _objRet.Response = new { id = objTalent.Talent_Code };
            }

            return _objRet;
        }
        public GenericReturn ChangeActiveStatus(Talent objInput)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (objInput.Talent_Code <= 0)
            {
                _objRet.Message = "Input Paramater 'id' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            if (string.IsNullOrEmpty(objInput.Is_Active))
            {
                _objRet.Message = "Input Paramater 'Status' is mandatory";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }
            else if (objInput.Is_Active.ToUpper() != "Y" && objInput.Is_Active.ToUpper() != "N")
            {
                _objRet.Message = "Input Paramater 'Status' is invalid";
                _objRet.IsSuccess = false;
                _objRet.StatusCode = HttpStatusCode.BadRequest;
                return _objRet;
            }

            #endregion

            if (_objRet.IsSuccess)
            {
                Talent objTalent = new Talent();

                objTalent = objTalentRepositories.Get(objInput.Talent_Code.Value);

                objTalent.Last_Updated_Time = DateTime.Now;
                objTalent.Last_Action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objTalent.Is_Active = objInput.Is_Active.ToUpper();

                objTalentRepositories.Update(objTalent);
                _objRet.Response = new { id = objTalent.Talent_Code };

            }

            return _objRet;
        }
    }
    #endregion
}
