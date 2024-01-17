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
    public class AcquisitionDealServices
    {
        private readonly AcquisitionDealRepositories objAcquisitionDealRepositories = new AcquisitionDealRepositories();

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
                    Acq_Deal_Rights objAcq_Deal_Rights = new Acq_Deal_Rights();

                    objAcq_Deal_Rights = objAcquisitionDealRepositories.GetById(id);

                    //objAcq_Deal_Rights.inserted_on = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.Rig))

                    //objAcq_Deal_Rights.inserted_on = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.Inserted_On.Value));
                    //objAcq_Deal_Rights.updated_on = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Rights.Last_Updated_Time));

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

    }


}
