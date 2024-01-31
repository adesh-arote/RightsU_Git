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
    public class AcqDealRunServices
    {
        private readonly AcqDealRunRepositories objAcq_Deal_Run_Repositories = new AcqDealRunRepositories();
        private readonly Acq_Deal_Run_Title_Repositories objAcq_Deal_Run_Title_Repositories = new Acq_Deal_Run_Title_Repositories();
        private readonly Acq_Deal_Run_Channel_Repositories objAcq_Deal_Run_Channel_Repositories = new Acq_Deal_Run_Channel_Repositories();
        private readonly Acq_Deal_Run_Yearwise_Run_Repositories objAcq_Deal_Run_Yearwise_Run_Repositories = new Acq_Deal_Run_Yearwise_Run_Repositories();
        private readonly Acq_Deal_Run_Repeat_On_Day_Repositories objAcq_Deal_Run_Repeat_On_Day_Repositories = new Acq_Deal_Run_Repeat_On_Day_Repositories();
        private readonly TitleRepositories ObjTitle_Repositories = new TitleRepositories();

        public GenericReturn GetDealRunList(string order, string sort, int deal_id, Int32 page = 0, Int32 size = 0, string deal_movie_ids = "", string channel_ids = "")
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            int noOfRecordSkip, noOfRecordTake;

            #region Input Validations

            if (!string.IsNullOrWhiteSpace(order))
            {
                if (order.ToUpper() != "ASC")
                {
                    if (order.ToUpper() != "DESC")
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR184"); // Input Paramater 'order' is not in valid format
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
                    sort = "Last_updated_Time";
                }
                else
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR186");
                }
            }
            else
            {
                sort = ConfigurationManager.AppSettings["defaultSort"];
            }

            if (deal_id <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR295"); // Input Paramater 'deal_run_id' is mandatory
            }

            #endregion

            AcqDealRunReturn _AcqDealRunReturn = new AcqDealRunReturn();
            List<USP_Acq_List_Runs> Acq_Deal_Runs = new List<USP_Acq_List_Runs>();

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal_Runs = objAcq_Deal_Run_Repositories.GetAcqDealRun_List(deal_id, deal_movie_ids, channel_ids);

                    _AcqDealRunReturn.paging.total = Acq_Deal_Runs.Count;

                    GlobalTool.GetPaging(page, size, Acq_Deal_Runs.Count, out noOfRecordSkip, out noOfRecordTake);

                    if (sort.ToLower() == "Inserted_On".ToLower())
                    {
                        if (order.ToUpper() == "ASC")
                        {
                            Acq_Deal_Runs = Acq_Deal_Runs.OrderBy(o => o.Inserted_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                        }
                        else
                        {
                            Acq_Deal_Runs = Acq_Deal_Runs.OrderByDescending(o => o.Inserted_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                        }
                    }
                    else if (sort.ToLower() == "Last_updated_Time".ToLower())
                    {
                        if (order.ToUpper() == "ASC")
                        {
                            Acq_Deal_Runs = Acq_Deal_Runs.OrderBy(o => o.Last_updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                        }
                        else
                        {
                            Acq_Deal_Runs = Acq_Deal_Runs.OrderByDescending(o => o.Last_updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                        }
                    }
                    else if (sort.ToLower() == "Title_Name".ToLower())
                    {
                        if (order.ToUpper() == "ASC")
                        {
                            Acq_Deal_Runs = Acq_Deal_Runs.OrderBy(o => o.Title_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                        }
                        else
                        {
                            Acq_Deal_Runs = Acq_Deal_Runs.OrderByDescending(o => o.Title_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                        }
                    }

                    var dealrunlist = (List<USP_Acq_List_Runs>)Acq_Deal_Runs;
                    dealrunlist.ForEach(i =>
                    {
                        i.Run_Definition_Type = i.Run_Definition_Type.Trim() == "C" ? "Channel" : (i.Run_Definition_Type.Trim() == "S" ? "Shared" : "NA");
                        i.Run_Type = i.Run_Type.Trim() == "U" ? "Unlimited" : "Limited";
                        i.Is_Rule_Right = i.Is_Rule_Right.Trim() == "Y" ? "Yes" : "No";
                        i.No_Of_Runs = i.No_Of_Runs!= null || i.No_Of_Runs.Value > 0 ? i.No_Of_Runs : 0;
                        i.No_Of_Runs_Sched = i.No_Of_Runs_Sched != null || i.No_Of_Runs_Sched.Value > 0 ? i.No_Of_Runs_Sched : 0;
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

            _AcqDealRunReturn.content = Acq_Deal_Runs;
            _AcqDealRunReturn.paging.page = page;
            _AcqDealRunReturn.paging.size = size;

            _objRet.Response = _AcqDealRunReturn;

            return _objRet;
        }

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
                    Acq_Deal_Run objAcq_Deal_Run = new Acq_Deal_Run();

                    objAcq_Deal_Run = objAcq_Deal_Run_Repositories.Get(id);

                    if (objAcq_Deal_Run != null)
                    {
                        //objAcq_Deal_Run.Inserted_On = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Run.Inserted_On.Value));
                        //objAcq_Deal_Run.Last_updated_Time = Convert.ToString(GlobalTool.DateToLinux(objAcq_Deal_Run.Last_updated_Time.Value));
                        //objAcq_Deal_Run.Last_action_By = objAcq_Deal_Run.Inserted_By != null || objAcq_Deal_Run.Inserted_By.Value > 0 ? objAcq_Deal_Run.Inserted_By : objAcq_Deal_Run.Last_action_By;

                        //objAcq_Deal_Run.prime_start_time = Convert.ToInt32(GlobalTool.TimeToLinux(objAcq_Deal_Run.Prime_Start_Time));
                        //objAcq_Deal_Run.prime_end_time = Convert.ToInt32(GlobalTool.TimeToLinux(objAcq_Deal_Run.Prime_End_Time));
                        //objAcq_Deal_Run.off_prime_start_time = Convert.ToInt32(GlobalTool.TimeToLinux(objAcq_Deal_Run.Off_Prime_Start_Time));
                        //objAcq_Deal_Run.off_prime_end_time = Convert.ToInt32(GlobalTool.TimeToLinux(objAcq_Deal_Run.Off_Prime_End_Time));
                    }
                    else
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR275"); // deal_run_id not found
                    }
                    _objRet.Response = objAcq_Deal_Run;
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

        public GenericReturn Post(Acq_Deal_Run objInput)
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
                _objRet = GlobalTool.SetError(_objRet, "ERR178"); // Input Paramater 'deal_id' is mandatory
            }

            if (string.IsNullOrWhiteSpace(objInput.Run_Type))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR276"); // Input Paramater 'run_type' is mandatory
            }

            if (objInput.Run_Type == "C" && (objInput.No_Of_Runs == null || objInput.No_Of_Runs <= 0))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR277"); // Input Paramater 'define_runs' is mandatory
            }

            if (string.IsNullOrWhiteSpace(objInput.Run_Definition_Type))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR278"); // Input Paramater 'run_definition_type' is mandatory
            }

            #region --- Acq_Deal_Run_Title ---

            if (objInput.titles == null || objInput.titles.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR172"); // Input Paramater 'Titles' is mandatory
            }
            else
            {
                for (int i = 0; i < objInput.titles.ToList().Count(); i++)
                {
                    if (objInput.titles.ToList()[i].Title_Code == null || objInput.titles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR173"); // Input Paramater 'titles.title_id' is mandatory
                    }

                    //string strQuery = "select Deal_Type_Name from Deal_Type where Deal_Type_Code = (select Deal_Type_Code from Title where Title_Code =" + objInput.Titles.ToList()[i].Title_Code;

                    var TitleDealTypeCode = ObjTitle_Repositories.GetById(objInput.titles.ToList()[i].Title_Code);

                    var DealTypeShow =  new SystemParameterServices().GetSystemParameterList().Where(x => x.Parameter_Name.ToUpper() == "AL_DealType_Show".ToUpper()).FirstOrDefault().Parameter_Value.Split(',');

                    if (DealTypeShow.Contains(Convert.ToString(TitleDealTypeCode.Deal_Type_Code)))
                    {
                        if (objInput.titles.ToList()[i].Episode_From == null || objInput.titles.ToList()[i].Episode_From <= 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR174"); // Input Paramater 'titles.episode_from' is mandatory
                        }

                        if (objInput.titles.ToList()[i].Episode_To == null || objInput.titles.ToList()[i].Episode_To <= 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR175"); // Input Paramater 'titles.episode_to' is mandatory
                        }
                    }    
                }
            }

            #endregion

            #region --- Acq_Deal_Run_Channel ---

            if (objInput.channels == null || objInput.channels.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR280"); // Input Paramater 'channels' is mandatory
            }
            else
            {
                for (int i = 0; i < objInput.channels.ToList().Count(); i++)
                {
                    if (objInput.channels.ToList()[i].Channel_Code == null || objInput.channels.ToList()[i].Channel_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR281"); // Input Paramater 'channels.channel_id' is mandatory

                    }

                    if (objInput.channels.ToList()[i].Min_Runs == null || objInput.channels.ToList()[i].Min_Runs <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR282"); // Input Paramater 'channels.define_runs' is mandatory
                        
                    }
                }
            }

            #endregion

            #region --- Acq_Deal_Run_Yearwise_Run ---

            if (objInput.yeardefinition != null || objInput.yeardefinition.Count() != 0)
            {
                for (int i = 0; i < objInput.yeardefinition.ToList().Count(); i++)
                {
                    if (string.IsNullOrWhiteSpace(objInput.yeardefinition.ToList()[i].start_date))
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR283"); // Input Paramater 'yeardefinition.start_date' is mandatory
                    }
                    else
                    {
                        try
                        {
                            objInput.Start_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.yeardefinition.ToList()[i].start_date));
                        }
                        catch (Exception ex)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR286"); // Input Paramater 'yeardefinition.start_date' is invalid
                        }
                    }

                    if (string.IsNullOrWhiteSpace(objInput.yeardefinition.ToList()[i].end_date))
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR287"); // Input Paramater 'yeardefinition.end_date' is mandatory
                    }
                    else
                    {
                        try
                        {
                            objInput.End_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.yeardefinition.ToList()[i].end_date));
                        }
                        catch (Exception ex)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR288"); // Input Paramater 'yeardefinition.end_date' is invalid
                        }
                    }

                    if (objInput.yeardefinition.ToList()[i].No_Of_Runs == null || objInput.yeardefinition.ToList()[i].No_Of_Runs <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR289"); // Input Paramater 'yeardefinition.define_runs' is mandatory
                    }
                }
            }

            #endregion

            #region --- Acq_Deal_Run_Repeat_On_Day ---

            if (objInput.repeaton != null || objInput.repeaton.Count() != 0)
            {
                for (int i = 0; i < objInput.repeaton.ToList().Count(); i++)
                {
                    if (objInput.repeaton.ToList()[i].Day_Code == null || objInput.repeaton.ToList()[i].Day_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR290"); // Input Paramater 'repeaton.day_id' is mandatory
                    }
                }
            }

            #endregion
        
            #endregion

            if (_objRet.IsSuccess)
            {
                objInput.Prime_Start_Time = GlobalTool.LinuxToTime(Convert.ToDouble(objInput.prime_start_time));
                objInput.Prime_End_Time = GlobalTool.LinuxToTime(Convert.ToDouble(objInput.prime_end_time));
                objInput.Off_Prime_Start_Time = GlobalTool.LinuxToTime(Convert.ToDouble(objInput.off_prime_start_time));
                objInput.Off_Prime_End_Time = GlobalTool.LinuxToTime(Convert.ToDouble(objInput.off_prime_end_time));
                objInput.Time_Lag_Simulcast = GlobalTool.LinuxToTime(Convert.ToDouble(objInput.time_lag));

                #region Pending Columns

                objInput.Run_Definition_Type = objInput.Run_Definition_Type != null ? objInput.Run_Definition_Type : "C";
                objInput.No_Of_Runs_Sched = 0;
                objInput.No_Of_AsRuns = 0;
                objInput.Is_Yearwise_Definition = objInput.yeardefinition.Count > 0 ? "Y" : "N"; 
                objInput.Is_Rule_Right = objInput.Right_Rule_Code != null || objInput.Right_Rule_Code.Value > 0 ? "Y" : "N";
                objInput.Channel_Type = objInput.Channel_Category_Code != null || objInput.Channel_Category_Code.Value > 0 ? "G" : "C";
                objInput.No_Of_Days_Hrs = 0;
                objInput.Is_Channel_Definition_Rights = "Y";
                objInput.Run_Definition_Group_Code = null;
                objInput.All_Channel = null;
                objInput.Prime_Time_Provisional_Run_Count = null;
                objInput.Prime_Time_AsRun_Count = null;
                objInput.Prime_Time_Balance_Count = null;
                objInput.Off_Prime_Time_Provisional_Run_Count = null;
                objInput.Off_Prime_Time_AsRun_Count = null;
                objInput.Off_Prime_Time_Balance_Count = null;
                objInput.Start_Date = null;
                objInput.End_Date = null;

                #endregion

                objInput.Inserted_On = DateTime.Now;
                objInput.Inserted_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                objInput.Last_updated_Time = DateTime.Now;
                objInput.Last_action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);

                List<Acq_Deal_Run_Title> lstRunTitles = new List<Acq_Deal_Run_Title>();
                foreach (var item in objInput.titles)
                {
                    Acq_Deal_Run_Title objruntitle = new Acq_Deal_Run_Title();

                    objruntitle.Acq_Deal_Run_Code = item.Acq_Deal_Run_Code;
                    objruntitle.Title_Code = item.Title_Code;
                    objruntitle.Episode_From = item.Episode_From;
                    objruntitle.Episode_To = item.Episode_To;
                    lstRunTitles.Add(objruntitle);
                }
                objInput.titles = lstRunTitles;


                List<Acq_Deal_Run_Channel> lstRunChannels = new List<Acq_Deal_Run_Channel>();
                foreach (var item in objInput.channels)
                {
                    Acq_Deal_Run_Channel objrunchannel = new Acq_Deal_Run_Channel();

                    objrunchannel.Acq_Deal_Run_Code = item.Acq_Deal_Run_Code;
                    objrunchannel.Channel_Code = item.Channel_Code;
                    objrunchannel.Min_Runs = item.Min_Runs;
                    objrunchannel.Max_Runs = null;
                    objrunchannel.No_Of_Runs_Sched = null;
                    objrunchannel.No_Of_AsRuns = null;
                    objrunchannel.Do_Not_Consume_Rights = null;
                    objrunchannel.Is_Primary = null;
                    objrunchannel.Inserted_On = null;
                    objrunchannel.Inserted_By = null;
                    objrunchannel.Last_updated_Time = null;
                    objrunchannel.Last_action_By = null;
                    lstRunChannels.Add(objrunchannel);
                }
                objInput.channels = lstRunChannels;

                List<Acq_Deal_Run_Yearwise_Run> lstRunYearwiseRun = new List<Acq_Deal_Run_Yearwise_Run>();
                foreach (var item in objInput.yeardefinition)
                {
                    Acq_Deal_Run_Yearwise_Run objrunyearwiserun = new Acq_Deal_Run_Yearwise_Run();

                    objrunyearwiserun.Acq_Deal_Run_Code = item.Acq_Deal_Run_Code;
                    objrunyearwiserun.Start_Date = GlobalTool.LinuxToDate(Convert.ToDouble(item.start_date));
                    objrunyearwiserun.End_Date = GlobalTool.LinuxToDate(Convert.ToDouble(item.end_date));
                    objrunyearwiserun.No_Of_Runs = item.No_Of_Runs;
                    objrunyearwiserun.No_Of_Runs_Sched = null;
                    objrunyearwiserun.No_Of_AsRuns = null;
                    objrunyearwiserun.Year_No = null;
                    objrunyearwiserun.Inserted_On = null;
                    objrunyearwiserun.Inserted_By = null;
                    objrunyearwiserun.Last_updated_Time = null;
                    objrunyearwiserun.Last_action_By = null;
                    lstRunYearwiseRun.Add(objrunyearwiserun);
                }
                objInput.yeardefinition = lstRunYearwiseRun;


                List<Acq_Deal_Run_Repeat_On_Day> lstRunRepeatOnDay = new List<Acq_Deal_Run_Repeat_On_Day>();
                foreach (var item in objInput.repeaton)
                {
                    Acq_Deal_Run_Repeat_On_Day objrunrepeatonday = new Acq_Deal_Run_Repeat_On_Day();

                    objrunrepeatonday.Acq_Deal_Run_Code = item.Acq_Deal_Run_Code;
                    objrunrepeatonday.Day_Code = item.Day_Code;
                    lstRunRepeatOnDay.Add(objrunrepeatonday);
                }
                objInput.repeaton = lstRunRepeatOnDay;

                objAcq_Deal_Run_Repositories.Add(objInput);

                _objRet.id = objInput.Acq_Deal_Run_Code;
            }

            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

            return _objRet;
        }

        public GenericReturn Put(Acq_Deal_Run objInput)
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

            if (objInput.Acq_Deal_Run_Code == null || objInput.Acq_Deal_Run_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR295"); // Input Paramater 'deal_run_id' is mandatory
            }

            if (objInput.Acq_Deal_Code == null || objInput.Acq_Deal_Code <= 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR178"); // Input Paramater 'deal_id' is mandatory
            }

            if (string.IsNullOrWhiteSpace(objInput.Run_Type))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR276"); // Input Paramater 'run_type' is mandatory
            }

            if (objInput.Run_Type == "C" && (objInput.No_Of_Runs == null || objInput.No_Of_Runs <= 0))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR277"); // Input Paramater 'define_runs' is mandatory
            }

            if (string.IsNullOrWhiteSpace(objInput.Run_Definition_Type))
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR278"); // Input Paramater 'run_definition_type' is mandatory
            }

            #region --- Acq_Deal_Run_Title ---

            if (objInput.titles == null || objInput.titles.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR172"); // Input Paramater 'titles' is mandatory
            }
            else
            {
                for (int i = 0; i < objInput.titles.ToList().Count(); i++)
                {
                    if (objInput.titles.ToList()[i].Title_Code == null || objInput.titles.ToList()[i].Title_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR173"); // Input Paramater 'titles.title_id' is mandatory
                    }

                    var TitleDealTypeCode = ObjTitle_Repositories.GetById(objInput.titles.ToList()[i].Title_Code);

                    var DealTypeShow = new SystemParameterServices().GetSystemParameterList().Where(x => x.Parameter_Name.ToUpper() == "AL_DealType_Show".ToUpper()).FirstOrDefault().Parameter_Value.Split(',');

                    if (DealTypeShow.Contains(Convert.ToString(TitleDealTypeCode.Deal_Type_Code)))
                    {
                        if (objInput.titles.ToList()[i].Episode_From == null || objInput.titles.ToList()[i].Episode_From <= 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR174"); // Input Paramater 'titles.episode_from' is mandatory
                        }

                        if (objInput.titles.ToList()[i].Episode_To == null || objInput.titles.ToList()[i].Episode_To <= 0)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR175"); // Input Paramater 'titles.episode_to' is mandatory
                        }
                    }
                }
            }

            #endregion

            #region --- Acq_Deal_Run_Channel ---

            if (objInput.channels == null || objInput.channels.Count() == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR280"); // Input Paramater 'channels' is mandatory
            }
            else
            {
                for (int i = 0; i < objInput.channels.ToList().Count(); i++)
                {
                    if (objInput.channels.ToList()[i].Channel_Code == null || objInput.channels.ToList()[i].Channel_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR281"); // Input Paramater 'channels.channel_id' is mandatory
                    }

                    if (objInput.channels.ToList()[i].Min_Runs == null || objInput.channels.ToList()[i].Min_Runs <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR282"); // Input Paramater 'channels.define_runs' is mandatory

                    }
                }
            }

            #endregion

            #region --- Acq_Deal_Run_Yearwise_Run ---

            if (objInput.yeardefinition != null || objInput.yeardefinition.Count() != 0)
            {
                for (int i = 0; i < objInput.yeardefinition.ToList().Count(); i++)
                {
                    if (string.IsNullOrWhiteSpace(objInput.yeardefinition.ToList()[i].start_date))
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR283"); // Input Paramater 'yeardefinition.start_date' is mandatory
                    }
                    else
                    {
                        try
                        {
                            objInput.Start_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.yeardefinition.ToList()[i].start_date));
                        }
                        catch (Exception ex)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR286"); // Input Paramater 'yeardefinition.start_date' is invalid
                        }
                    }

                    if (string.IsNullOrWhiteSpace(objInput.yeardefinition.ToList()[i].end_date))
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR287"); // Input Paramater 'yeardefinition.end_date' is mandatory
                    }
                    else
                    {
                        try
                        {
                            objInput.End_Date = GlobalTool.LinuxToDate(Convert.ToDouble(objInput.yeardefinition.ToList()[i].end_date));
                        }
                        catch (Exception ex)
                        {
                            _objRet = GlobalTool.SetError(_objRet, "ERR288"); // Input Paramater 'yeardefinition.end_date' is invalid
                        }
                    }

                    if (objInput.yeardefinition.ToList()[i].No_Of_Runs == null || objInput.yeardefinition.ToList()[i].No_Of_Runs <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR289"); // Input Paramater 'yeardefinition.define_runs' is mandatory
                    }
                }
            }

            #endregion

            #region --- Acq_Deal_Run_Repeat_On_Day ---

            if (objInput.repeaton != null || objInput.repeaton.Count() != 0)
            {
                for (int i = 0; i < objInput.repeaton.ToList().Count(); i++)
                {
                    if (objInput.repeaton.ToList()[i].Day_Code == null || objInput.repeaton.ToList()[i].Day_Code <= 0)
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR290"); // Input Paramater 'repeaton.day_id' is mandatory
                    }
                }
            }

            #endregion

            #endregion

            if (_objRet.IsSuccess)
            {
                var objDealRun = objAcq_Deal_Run_Repositories.Get(objInput.Acq_Deal_Run_Code.Value);

                if (objDealRun != null)
                {
                    objInput.Prime_Start_Time = GlobalTool.LinuxToTime(Convert.ToDouble(objInput.prime_start_time));
                    objInput.Prime_End_Time = GlobalTool.LinuxToTime(Convert.ToDouble(objInput.prime_end_time));
                    objInput.Off_Prime_Start_Time = GlobalTool.LinuxToTime(Convert.ToDouble(objInput.off_prime_start_time));
                    objInput.Off_Prime_End_Time = GlobalTool.LinuxToTime(Convert.ToDouble(objInput.off_prime_end_time));
                    objInput.Time_Lag_Simulcast = GlobalTool.LinuxToTime(Convert.ToDouble(objInput.time_lag));

                    #region Pending Columns

                    objInput.Run_Definition_Type = objDealRun.Run_Definition_Type;
                    objInput.No_Of_Runs_Sched = objDealRun.No_Of_Runs_Sched;
                    objInput.No_Of_AsRuns = objDealRun.No_Of_AsRuns;
                    objInput.Is_Yearwise_Definition = objDealRun.Is_Yearwise_Definition;
                    objInput.Is_Rule_Right = objDealRun.Is_Rule_Right;
                    objInput.Channel_Type = objDealRun.Channel_Type;
                    objInput.No_Of_Days_Hrs = objDealRun.No_Of_Days_Hrs;
                    objInput.Is_Channel_Definition_Rights = objDealRun.Is_Channel_Definition_Rights;
                    objInput.Run_Definition_Group_Code = objDealRun.Run_Definition_Group_Code;
                    objInput.All_Channel = objDealRun.All_Channel;
                    objInput.Prime_Time_Provisional_Run_Count = objDealRun.Prime_Time_Provisional_Run_Count;
                    objInput.Prime_Time_AsRun_Count = objDealRun.Off_Prime_Time_AsRun_Count;
                    objInput.Prime_Time_Balance_Count = objDealRun.Prime_Time_Balance_Count;
                    objInput.Off_Prime_Time_Provisional_Run_Count = objDealRun.Off_Prime_Time_Provisional_Run_Count;
                    objInput.Off_Prime_Time_AsRun_Count = objDealRun.Off_Prime_Time_AsRun_Count;
                    objInput.Off_Prime_Time_Balance_Count = objDealRun.Off_Prime_Time_Balance_Count;
                    objInput.Start_Date = objDealRun.Start_Date;
                    objInput.End_Date = objDealRun.End_Date;

                    #endregion

                    objInput.Inserted_On = objDealRun.Inserted_On;
                    objInput.Inserted_By = objDealRun.Inserted_By;
                    objInput.Last_action_By = Convert.ToInt32(HttpContext.Current.Request.Headers["UserId"]);
                    objInput.Last_updated_Time = DateTime.Now;

                    #region Acq_Deal_Run_Title

                    objDealRun.titles.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.titles)
                    {
                        Acq_Deal_Run_Title objRt = (Acq_Deal_Run_Title)objDealRun.titles.Where(t => t.Title_Code == item.Title_Code).Select(i => i).FirstOrDefault();

                        if (objRt == null)
                            objRt = new Acq_Deal_Run_Title();
                        if (objRt.Acq_Deal_Run_Title_Code > 0)
                        {
                            objRt.EntityState = State.Unchanged;
                            objRt.Acq_Deal_Run_Code = objInput.Acq_Deal_Run_Code;
                            objRt.Title_Code = item.Title_Code;
                            objRt.Episode_From = item.Episode_From;
                            objRt.Episode_To = item.Episode_To;
                        }
                            
                        else
                        {
                            objRt.EntityState = State.Added;
                            objRt.Acq_Deal_Run_Code = objInput.Acq_Deal_Run_Code;
                            objRt.Title_Code = item.Title_Code;
                            objRt.Episode_From = item.Episode_From;
                            objRt.Episode_To = item.Episode_To;
                            objDealRun.titles.Add(objRt);
                        }
                    }

                    foreach (var item in objDealRun.titles.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objAcq_Deal_Run_Title_Repositories.Delete(item);
                    }

                    var objRunTitle = objDealRun.titles.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objRunTitle.ForEach(i => objDealRun.titles.Remove(i));

                    objInput.titles = objDealRun.titles;

                    #endregion

                    #region Acq_Deal_Run_Channel

                    objDealRun.channels.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.channels)
                    {
                        Acq_Deal_Run_Channel objRc = (Acq_Deal_Run_Channel)objDealRun.channels.Where(t => t.Channel_Code == item.Channel_Code).Select(i => i).FirstOrDefault();

                        if (objRc == null)
                            objRc = new Acq_Deal_Run_Channel();
                        if (objRc.Acq_Deal_Run_Channel_Code > 0)
                        {
                            objRc.EntityState = State.Unchanged;
                            objRc.Acq_Deal_Run_Code = objInput.Acq_Deal_Run_Code;
                            objRc.Channel_Code = item.Channel_Code;
                            objRc.Min_Runs = item.Min_Runs;
                            objRc.Max_Runs = item.Max_Runs;
                            objRc.No_Of_Runs_Sched = item.No_Of_Runs_Sched;
                            objRc.No_Of_AsRuns = item.No_Of_AsRuns;
                            objRc.Do_Not_Consume_Rights = item.Do_Not_Consume_Rights;
                            objRc.Is_Primary = item.Is_Primary;
                            objRc.Inserted_By = item.Inserted_By;
                            objRc.Inserted_On = item.Inserted_On;
                            objRc.Last_action_By = item.Last_action_By;
                            objRc.Last_updated_Time = item.Last_updated_Time;
                        }
                        else
                        {
                            objRc.Acq_Deal_Run_Code = objInput.Acq_Deal_Run_Code;
                            objRc.Channel_Code = item.Channel_Code;
                            objRc.Min_Runs = item.Min_Runs;
                            objRc.Max_Runs = item.Max_Runs;
                            objRc.No_Of_Runs_Sched = item.No_Of_Runs_Sched;
                            objRc.No_Of_AsRuns = item.No_Of_AsRuns;
                            objRc.Do_Not_Consume_Rights = item.Do_Not_Consume_Rights;
                            objRc.Is_Primary = item.Is_Primary;
                            objRc.Inserted_By = item.Inserted_By;
                            objRc.Inserted_On = item.Inserted_On;
                            objRc.Last_action_By = item.Last_action_By;
                            objRc.Last_updated_Time = item.Last_updated_Time;
                            objDealRun.channels.Add(objRc);
                        }
                    }

                    foreach (var item in objDealRun.channels.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objAcq_Deal_Run_Channel_Repositories.Delete(item);
                    }

                    var objRunChannel = objDealRun.channels.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objRunChannel.ForEach(i => objDealRun.channels.Remove(i));

                    objInput.channels = objDealRun.channels;

                    #endregion

                    #region Acq_Deal_Run_Yearwise_Run

                    objDealRun.yeardefinition.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.yeardefinition)
                    {
                        Acq_Deal_Run_Yearwise_Run objRc = (Acq_Deal_Run_Yearwise_Run)objDealRun.yeardefinition.Where(t => t.Acq_Deal_Run_Yearwise_Run_Code == item.Acq_Deal_Run_Yearwise_Run_Code).Select(i => i).FirstOrDefault();

                        if (objRc == null)
                            objRc = new Acq_Deal_Run_Yearwise_Run();
                        if (objRc.Acq_Deal_Run_Yearwise_Run_Code > 0)
                        {
                            objRc.EntityState = State.Unchanged;
                            objRc.Acq_Deal_Run_Code = objInput.Acq_Deal_Run_Code;
                            objRc.Start_Date = GlobalTool.LinuxToDate(Convert.ToDouble(item.start_date));
                            objRc.End_Date = GlobalTool.LinuxToDate(Convert.ToDouble(item.end_date));
                            objRc.No_Of_Runs = item.No_Of_Runs;
                            objRc.No_Of_Runs_Sched = item.No_Of_Runs_Sched;
                            objRc.No_Of_AsRuns = item.No_Of_AsRuns;
                            objRc.Year_No = item.Year_No;
                            objRc.Inserted_By = item.Inserted_By;
                            objRc.Inserted_On = item.Inserted_On;
                            objRc.Last_action_By = item.Last_action_By;
                            objRc.Last_updated_Time = item.Last_updated_Time;
                        }
                        else
                        {
                            objRc.Acq_Deal_Run_Code = objInput.Acq_Deal_Run_Code;
                            objRc.Start_Date = GlobalTool.LinuxToDate(Convert.ToDouble(item.start_date));
                            objRc.End_Date = GlobalTool.LinuxToDate(Convert.ToDouble(item.end_date));
                            objRc.No_Of_Runs = item.No_Of_Runs;
                            objRc.No_Of_Runs_Sched = item.No_Of_Runs_Sched;
                            objRc.No_Of_AsRuns = item.No_Of_AsRuns;
                            objRc.Year_No = item.Year_No;
                            objRc.Inserted_By = item.Inserted_By;
                            objRc.Inserted_On = item.Inserted_On;
                            objRc.Last_action_By = item.Last_action_By;
                            objRc.Last_updated_Time = item.Last_updated_Time;
                            objDealRun.yeardefinition.Add(objRc);
                        }
                    }

                    foreach (var item in objDealRun.yeardefinition.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objAcq_Deal_Run_Yearwise_Run_Repositories.Delete(item);
                    }

                    var objYearwiseRun = objDealRun.yeardefinition.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objYearwiseRun.ForEach(i => objDealRun.yeardefinition.Remove(i));

                    objInput.yeardefinition = objDealRun.yeardefinition;

                    #endregion

                    #region Acq_Deal_Run_Repeat_On_Day

                    objDealRun.repeaton.ToList().ForEach(i => i.EntityState = State.Deleted);

                    foreach (var item in objInput.repeaton)
                    {
                        Acq_Deal_Run_Repeat_On_Day objRd = (Acq_Deal_Run_Repeat_On_Day)objDealRun.repeaton.Where(t => t.Acq_Deal_Run_Repeat_On_Day_Code == item.Acq_Deal_Run_Repeat_On_Day_Code).Select(i => i).FirstOrDefault();

                        if (objRd == null)
                            objRd = new Acq_Deal_Run_Repeat_On_Day();
                        if (objRd.Acq_Deal_Run_Repeat_On_Day_Code > 0)
                        {
                            objRd.EntityState = State.Unchanged;
                            objRd.Acq_Deal_Run_Code = objInput.Acq_Deal_Run_Code;
                            objRd.Day_Code = item.Day_Code;               
                        }
                        else
                        {
                            objRd.EntityState = State.Added;
                            objRd.Acq_Deal_Run_Code = objInput.Acq_Deal_Run_Code;
                            objRd.Day_Code = item.Day_Code;
                            objDealRun.repeaton.Add(objRd);
                        }
                    }

                    foreach (var item in objDealRun.repeaton.ToList().Where(x => x.EntityState == State.Deleted))
                    {
                        objAcq_Deal_Run_Repeat_On_Day_Repositories.Delete(item);
                    }

                    var objRptOnDay = objDealRun.repeaton.ToList().Where(x => x.EntityState == State.Deleted).ToList();
                    objRptOnDay.ForEach(i => objDealRun.repeaton.Remove(i));

                    objInput.repeaton = objDealRun.repeaton;

                    #endregion

                    objAcq_Deal_Run_Repositories.Update(objInput);
                }
                else
                {
                    _objRet = GlobalTool.SetError(_objRet, "ERR275"); // deal_run_id not found
                }
                _objRet.id = objInput.Acq_Deal_Run_Code;
            }

            if (!_objRet.IsSuccess)
            {
                _objRet.Errors = GlobalTool.GetErrorList(_objRet.Errors);
            }

            return _objRet;
        }

        public GenericReturn Delete(Int32 deal_Run_id)
        {
            GenericReturn _objRet = new GenericReturn();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;
            _objRet.StatusCode = HttpStatusCode.OK;

            #region Input Validation

            if (deal_Run_id == 0)
            {
                _objRet = GlobalTool.SetError(_objRet, "ERR295"); // Input Paramater 'deal_run_id' is mandatory
            }

            #endregion

            try
            {
                if (_objRet.IsSuccess)
                {
                    Acq_Deal_Run objDealRun = new Acq_Deal_Run();

                    objDealRun = objAcq_Deal_Run_Repositories.Get(deal_Run_id);

                    if (objDealRun != null)
                    {
                        objAcq_Deal_Run_Repositories.Delete(objDealRun);

                        _objRet.id = objDealRun.Acq_Deal_Run_Code;
                    }
                    else
                    {
                        _objRet = GlobalTool.SetError(_objRet, "ERR275"); // deal_run_id not found
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
