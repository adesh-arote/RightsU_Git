namespace UTO.Notification.Teams
{
    partial class ProjectInstaller
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.NotificationserviceProcessInstaller = new System.ServiceProcess.ServiceProcessInstaller();
            this.NotificationserviceInstaller = new System.ServiceProcess.ServiceInstaller();
            // 
            // NotificationserviceProcessInstaller
            // 
            this.NotificationserviceProcessInstaller.Account = System.ServiceProcess.ServiceAccount.LocalService;
            this.NotificationserviceProcessInstaller.Password = null;
            this.NotificationserviceProcessInstaller.Username = null;
            // 
            // NotificationserviceInstaller
            // 
            this.NotificationserviceInstaller.ServiceName = "UTO.Notification.Teams";
            // 
            // ProjectInstaller
            // 
            this.Installers.AddRange(new System.Configuration.Install.Installer[] {
            this.NotificationserviceProcessInstaller,
            this.NotificationserviceInstaller});

        }

        #endregion

        private System.ServiceProcess.ServiceProcessInstaller NotificationserviceProcessInstaller;
        private System.ServiceProcess.ServiceInstaller NotificationserviceInstaller;
    }
}