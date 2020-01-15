az cognitiveservices account keys list \
    --name aiml20-computer-vision \
    --resource-group aiml20-demo 

KEY="YOUR-KEY-HERE"

IMG="https://raw.githubusercontent.com/microsoft/ignite-learning-paths-training-aiml/master/aiml20/test%20images/man%20in%20hardhat.jpg"
echo $IMG

curl -H "Ocp-Apim-Subscription-Key: $KEY" \
      -H "Content-Type: application/json" \
      "https://westus2.api.cognitive.microsoft.com/vision/v2.0/analyze?visualFeatures=Tags&language=en" \
      -d "{\"url\":\"$IMG\"}"   

# drill.jpg
IMG="https://raw.githubusercontent.com/microsoft/ignite-learning-paths-training-aiml/master/aiml20/test%20images/drill.jpg"
curl -H "Ocp-Apim-Subscription-Key: $KEY" \
      -H "Content-Type: application/json" \
      "https://westus2.api.cognitive.microsoft.com/vision/v2.0/analyze?visualFeatures=Tags&language=en" \
      -d "{\"url\":\"$IMG\"}"   


