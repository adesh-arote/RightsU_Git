using System;
using UTOFrameWork.FrameworkClasses;
	/// <summary>
	/// Summary description for UploadErrorDetail.
	/// </summary>
	public class UploadErrorDetail:Persistent
	{
		public UploadErrorDetail(){
			OrderByColumnName = "upload_detail_code";
			OrderByCondition = "ASC";
			//orderByReverseCondition = "DESC";
		}
		private long _uploadDetailCode;
		private int _fileCode;
		private int _rowNum;
		private string _rowDelimed;
		private string _errColumns;
		private string _uploadType;
		public long uploadDetailCode
		{
			get
			{
				return _uploadDetailCode;
			}set
			 {
				_uploadDetailCode=value;
			 }
		}
		public int fileCode
		{
			get
			{
				return _fileCode;
			}set
			 {
				 _fileCode=value;
			 }
		}
		public int rowNum
		{
			get
			{
				return _rowNum;
			}set
			 {
				 _rowNum=value;
			 }
		}
		public string rowDelimed
		{
			get
			{
				return _rowDelimed;
			}set
			 {
				 _rowDelimed=value;
			 }
		}
		public string errColumns
		{
			get
			{
				return _errColumns;
			}set
			 {
				 _errColumns=value;
			 }
		}
		public string uploadType
		{
			get
			{
				return _uploadType;
			}set
			 {
				 _uploadType=value;
			 }
		}
		public override DatabaseBroker GetBroker()
		{
			return new UploadErrorDetailBroker();
		}
		public override void LoadObjects()
		{
			
		}
		public override void UnloadObjects()
		{

		}

	}
