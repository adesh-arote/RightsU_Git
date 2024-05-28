using RightsUMusic.Entity;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using RightsUMusic.DAL.Repository;

namespace RightsUMusic.BLL.Services
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
    }
    public class Login_DetailsServices
    {
        private readonly Login_DetailsRepositories objLogin_DetailsRepositories;

        public Login_DetailsServices()
        {
            this.objLogin_DetailsRepositories = new Login_DetailsRepositories();
        }

        public void AddEntity(Login_Details param)
        {
            objLogin_DetailsRepositories.Add(param);
        }

        public IEnumerable<Login_Details> GetUserList()
        {
            return objLogin_DetailsRepositories.GetAll();
        }

        public Login_Details GetUserByID(int ID)
        {
            return objLogin_DetailsRepositories.Get(ID);
        }

        public IEnumerable<Login_Details> SearchFor(object param)
        {
            return objLogin_DetailsRepositories.SearchFor(param);
        }

        public void UpdateUserLoginDetails(Login_Details obj)
        {
            objLogin_DetailsRepositories.Update(obj);
        }
    }

    public class SystemParameterServices
    {
        private readonly SystemParametersRepositories objSystemParametersRepositories;
        public SystemParameterServices()
        {
            this.objSystemParametersRepositories = new SystemParametersRepositories();
        }
        public IEnumerable<MHSystemParameter> GetSystemParameterList()
        {
            return objSystemParametersRepositories.GetAll();
        }
        public IEnumerable<MHSystemParameter> SearchFor(object param)
        {
            return objSystemParametersRepositories.SearchFor(param);
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

    public class MHUsersServices
    {
        private readonly MHUsersRepositories objMHUsersRepositories = new MHUsersRepositories(); 
        public IEnumerable<MHUsers> SearchFor(object param)
        {
            return objMHUsersRepositories.SearchFor(param);
        }
    }

    public class VendorServices
    {
        private readonly VendorRepositories objVendorRepositories = new VendorRepositories();
        public Vendor GetVendorByID(int VendorCode)
        {
            return objVendorRepositories.Get(VendorCode);
        }
    }

    public class MHPlayListServices
    {
        private readonly MHPlayListRepositories objMHPlayListRepositories = new MHPlayListRepositories();
        public IEnumerable<MHPlayList> SearchFor(object param)
        {
            return objMHPlayListRepositories.SearchFor(param);
        }
    }

    public class MHPlayListSongServices
    {
        private readonly MHPlayListSongRepositories objMHPlayListSongRepositories = new MHPlayListSongRepositories();
        public IEnumerable<MHPlayListSong> SearchFor(object param)
        {
            return objMHPlayListSongRepositories.SearchFor(param);
        }
    }

    //public class UserPasswordDetailService
    //{
    //    private readonly UserRepositories objUserRepository;

    //    public UserPasswordDetailService()
    //    {
    //        this.objUserRepository = new UserRepositories();
    //    }

    //    public IEnumerable<User> GetUserList()
    //    {
    //        return objUserRepository.GetAll();
    //    }

    //    public User GetUserByID(int ID)
    //    {
    //        return objUserRepository.Get(ID);
    //    }

    //    public IEnumerable<User> SearchForUser(object param)
    //    {
    //        return objUserRepository.SearchFor(param);
    //    }
    //}
}
