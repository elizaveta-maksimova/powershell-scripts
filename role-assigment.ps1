Login-AzureRmAccount

Get-AzureRmSubscription

Login-AzureRmAccount

$role = Get-AzureRmRoleDefinition "Website Contributor"
$role.Id = $null
$role.Name = "Azure Intern Team 3"
$role.Description = "Shkola 1010 Azure Internship"
$role.Actions.Clear()
$role.Actions.Add("Microsoft.Storage/*")
$role.Actions.Add("Microsoft.Authorization/*")
$role.Actions.Add("Microsoft.Web/*")
$role.Actions.Add("Microsoft.Resources/deployments/*")
$role.Actions.Add("Microsoft.Resources/subscriptions/resourceGroups/read")
$role.Actions.Add("Microsoft.Sql/*")
$role.Actions.Add("Microsoft.Insights/*")
$role.AssignableScopes.Clear()
$role.AssignableScopes.Add("/subscriptions/b15c8f0e-8628-4317-8031-7737ea09f1c7/resourceGroups/InternshipTeam3")

New-AzureRmRoleDefinition -Role $role

Get-AzureRmResourceProvider -ListAvailable | ? {$_.RegistrationState -eq “NotRegistered”} | select ProviderNamespace

Get-AzureRmResourceProvider -ProviderNamespace Microsoft.Insights