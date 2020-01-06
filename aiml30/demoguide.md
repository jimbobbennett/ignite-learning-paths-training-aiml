# Demo Guide
> 💡 You must have completed the [deployment](demosetup.md) before attempting to do the demo.

# Demo 1: Data Prep Demo with App
In the first demo highlight the data preparation that was discussed in the slides for Time Series models. Walk through step by step how to do this in the C# demo app. Make sure to highlight that this can be done in any language.

To navigate through code with `F12` and `CTRL-` shortcuts download the Visual Studio Shortcut Extension for VS Code [here](https://marketplace.visualstudio.com/items?itemName=ms-vscode.vs-keybindings). This is super useful and keeps from having to scroll around trying to find things. (Note this extension doesn't work on mac or linux)

### Data Prep Demo Video [here](https://youtu.be/u1ppYaZuNmo?t=751)

> 💡 You must have completed the [deployment](demosetup.md) before attempting to do the demo.

### 1. Open the `IgniteAimlDataApp` App. I personally like to have this open before I start the talk so I can just flip to it.
* Open the `Program.cs` file
* Go to `GetProcessedDataForScore` method by right clicking and select `Go To Definition` or hitting `F12`
    * Load data from data source. In this example we are loading for a local excel file in the solution.
* `F12` to `AddWeeksToPredict` method and discuss logic.
    * Get latest date and add 4 future weeks from that date
    * Since the data is weekly and we want to know if a holiday occured during the week we calculate all dates that occured in the week and populate a collection called `DatesInWeek`
    * Next create time futures for the 4 future weeks added to the collection.
* `F12` to `CreateTimeFeatures` method from within `AddWeeksToPredict` logic and discuss logic.
    * Use the current time property to calculate the time and holiday features needed.
* `CTRL-` to navigate back to `AddWeeksToPredict`
* `F12` to `CreateFourierFeatures`
    * Calcuate Fourier Term features from the seasonality of 52 for our weekly data features. 
* `CTRL-` to navigate back to `GetProcessedDataForScore`
* `F12` to `CreateLagFeatures` method and discuss logic.
    * Add the 26 prior week sales values to the current row.
* `CTRL-` to navigate back to `GetProcessedDataForScore`

* Data Demo Backup Options
    * Use the embedded mp4 video in the hidden slide. Talk along side this video without sound.
    * Start at slide 21 and show the data prep code in static slide steps.

# Demo 2: Build Model with Azure Machine Learning Designer
💡 You must have completed the [deployment](demosetup.md) before attempting to do the demo.

### Full Model Building Live Demo Video [here](https://youtu.be/u1ppYaZuNmo?t=1278)

### 1. Create Resource and Upload Dataset

* Create Azure Machine Learning Studio Resource and Navigate to the new Workspace.
    * Review high level where the different tools are that were discussed in the slides.
    * Video Resources for this step:
        * [Here](https://globaleventcdn.blob.core.windows.net/assets/aiml/aiml30/CreateAMLNavToWorkspace.mp4) is video of this step without sound.
        * [Here](https://youtu.be/u1ppYaZuNmo?t=1278) is video of how to create the resource with audio.
* Upload the dataset to the Datasets in AML
    * Click `Datasets`
    * Click `Create from datastore` or from local (whichever you prefer)
        * NOTE: you should have already uploaded the dataset to the datastore in the demo setup steps.
    * Fill in required fields and select the `workspaceblobstorage` option
    * Click `Create`
    * Optional: Step through the data prep feature in the datasets upload for AML

### 2. Launch Designer and Explain Tool Features

* In the studio select 'Designer' on the left navigation
* Summarize the different modules in the left nav including the test datasets.

### 3. Start Building the  Model

* Drag and drop the dataset onto the experiment workspace
    * Note the file upload module as an option for getting data into workspace
* Drag the `Select Columns in Dataset` onto the workspace
    * Click `Edit columns` from the parameters menu on the right side.
    * Click `By Name`
    * Click `Add All`
    * Click `Minus` icon on the `Time` column to exclude it
* Drag the `Split Data` onto the workspace
    * Edit the parameters to split the data 70/30. 
    * The split percentage is not a rule and can change base on different model needs.
* Drag the `Train Model` onto the workspace
    * Select the label column name `Value` from the parameters on the right
* Drag the `Boosted Decision Tree Regression` onto the workspace
* Drag the `Score Model` onto the workspace
* Drag the `Evaluate` onto the workspace
* Connect the `Split Data` module to `Train Model` for the training data and `Score Model` for scoring the predicted results with unseen data.
* Connect `Train Model` to the training algorithm `Boosted Decision Tree Regression` module.
* Connect `Score Model` with the `Evaluate` module.
* This is normally where you would run the model _however_ it takes too long to run in the demo. Discuss how you would click the `Run` button in the bottom nav and select compute. This will segue nicely into talking about how to create compute resources in AML.

* Rename the created column `Scored Labels` to `Forecast`
    * Drag the `Edit Metadata` onto the workspace
    * Connect `Score Model` with the `Edit Metadata` module
    * In the `Parameters` of the `Edit Metadata` module. Click `Edit Columns`
    * Type `Score Labels` into the text box (no need to change any of the defaults)
    * Click `Save`
    * Next update the `New Column Name` field on the `Parameters` to `Forecast`
* Transform the normalized value back to full item counts
    * Drag the `Apply Math Operation` onto the workspace
    * Connect `Edit Metadata` to `Apply Math Operation`
    * Set the `Basic math function` to `Exp`
    * Click `Edit Columns` and type `Value` and `Forecast`
    * Click `Save`
    * Set the `Output mode` to `Inplace`
* Drag the `Select Columns in Dataset` module onto the workspace
* Connect the `Apply Math Operation` to `Select Columns in Dataset`
* Click `Edit Columns` and type the following column names `ID1,ID2,Value,Forecast`

### 4. Discuss Compute Target Creation

* Click the `Compute` navigation item
* Click `Add`
* Discuss the different compute types and what they are used for. The computes used for this demo are a `Machine Learning Compute` for training and the `Kubernetes Service` for deploying the API.

### 5. Explain Trained Model
* Navigate back to Visual Designer
* Right Click on the second module in the model to Visualize the data (most likely the `Select Columns in Dataset`)
* Quickly scroll through the data to show how the data looks.
* Click on a column and show how the the tool creates visualizations in the right panel.
* Visualize the `Score Model` module to show how the model predicted on the unseen data
* Visualize the `Evaluate Model` module and discuss the metrics used to score.
    * Click `More Help` in the right panel of the parameters.
    * Highlight that every module has a link to the docs in the parameters that will explain what the module is doing.
    * Scroll down and show the metrics explanations in the docs for the model.
    
### 6. Create Inference Pipeline and Deploy the Model
This is normally where you would create the `Inference Pipeline` to deploy it to a web service _however_ we have done these steps in advance. 
* Discuss these steps _do not do them live_:
    * Click `Create inference pipeline` then select `Real-time inference pipeline`
    * Ensure the `Web Service Output` is connected to the last data processing step module `Select Columns in Dataset`
    * Click `Run`
    * Click `Deploy`
* After discussing the steps to create the `Inference Pipeline` navigate to the deployed web service from the left nav.
* Click on the name of the web service created in advance.
* Click `Test` and show how it performs on a scored data item.
* Click `Consume` and show the sample code provided for integrating the web service.


# Demo 3: Testing API with C# console app (dotnet core)

> 💡 You must have completed the [deployment](demosetup.md) before attempting to do the demo.

### API Demo Test Video [here](https://youtu.be/u1ppYaZuNmo?t=2136)

* Copy the API key from the `Consume` tab
* Open the `App.config` and paste it in the value attribute
* Copy the `Request-Response Url` from the `Consume` tab
* Open the `Program.cs` and paste the value in `client.BaseAddress = new Uri("");`
* Right click `Program.cs` and select `Open in Terminal`
* Type the command `dotnet run` to run the console app
* To use the default values of StoreID (ID1) of 2 and ItemID (ID2) of 1 and the number of weeks to predict. Just type `y`
* This will run and should return the predicted values for the next 4 weeks.
