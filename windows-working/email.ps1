# Email.ps1
function SendAlertEmail($Body){
   
    $From = "morgan.rees@mymail.champlain.edu"
    $To = "morgan.rees@mymail.champlain.edu"
    $Subject = "Suspicious Activity"
    
   $Password = "gyfz eymb whgn fasj" | ConvertTo-SecureString -AsPlainText -Force
   $Credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $From, $Password

   Send-MailMessage -From $From -To $To -Subject $Subject -Body $Body -SmtpServer "smtp.gmail.com" -Port 587 -UseSsl -Credential $Credential 
}

SendAlertEmail "Body of email"
