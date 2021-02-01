# Azure-Cost-Management with Powershell
A cool way to save costs on Azure (convience for a sandbox) before the big sentence aka **DELETING** 😱 resource(s).
<br><br>The example will focus on Synapse Pool and Stream analytics job. However the script could be used as a template and be leveraged to suit different use cases.

# Step 1 Identify what resources cost the most in my subscription

![image](https://user-images.githubusercontent.com/49620357/106396964-19647880-63d9-11eb-8794-b62e6be7eb9f.png)

In the case above, Synapse pools are the resources costing the most in the subscription.

# Step 2 Understand how any resource(s) identified in step 1 is/are priced and how you could modify the resource(s) to make the cost cheaper

* Have a look at the Azure Price Calculator 💰
  * https://azure.microsoft.com/en-us/pricing/calculator/
* Have a look at the Azure Powershell documentation 📖. Look at the Reference part especially to list what options are available for your resources (Pause, Stop, Reduce the compute, etc)
  * https://docs.microsoft.com/en-us/powershell/azure/?view=azps-5.4.0
  
# Step 3 Create a Powershell script that would "minimize" the costs based on the options identified in Step 2

In this case, Synapse Pools are the main "problem". 
<br><br>Let's minimize the cost for those resources. 
<br><br>The stream analytic job will be also modified.

What we will be doing for:

* **Synapse**
  * Suspend the pool with the command Suspend-AzSynapseSqlPool

* **Stream Analytic job**
  * Stop the job with the command Stop-AzStreamAnalyticsJob

The script will iterate through all the resources in the subscription. 
<br><br>Each Synapse Pool running will be paused.
<br><br>Each Streamin Analytic job running will be stopped.

# Step 4 Create a runbook and schedule it to run on a regular basis

The following link will guide you to create and schedule a runbook:
https://docs.microsoft.com/en-us/azure/automation/learn/automation-tutorial-runbook-textual-powershell
When creating the job, make sure you add any module required (*see the example provided*)

The final step is to decide the frequency of the job. For example, run the runbook everyday at 10pm.

After running the script in a runbook, you can verify what has been modified:
![image](https://user-images.githubusercontent.com/49620357/106397892-b9240580-63dd-11eb-8a47-18dd5c30d74d.png)
