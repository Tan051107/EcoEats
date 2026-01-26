import visionClient from './VisionClient.js'


export async function visionAnalyze(image){ //in URI
    const request = {
        image:{
            source:{
                //imageUri:image
                content:image
            }
        },
        features:
            [
                {type:"LABEL_DETECTION" , maxResults:10},
                {type:"OBJECT_LOCALIZATION" , maxResults:10},
                {type:"LOGO_DETECTION" , maxResults:5}
            ]        
    }

    const [result] = await visionClient.annotateImage(request);

    const labels = result.labelAnnotations?.filter(label=>label.score > 0.7)
                                           .map(label=>(
                                            {
                                                label:label.description,
                                                confidence:label.confidence
                                            }
                                           ))
    
    const objectsRaw = result?.localizedObjectAnnotations.filter(object=>object.score>0.7);
    const objectsCount ={}
    for (const object of objectsRaw){
        const name = object.name
        if(!objectsCount[name]){
            objectsCount[name] =1;
        }
        else{
            objectsCount[name]++;
        }
    };

    const objects = Object.entries(objectsCount).map(([name,count])=>(
        {
           name,
           count 
        }
    ))


    const logos = result?.logoAnnotations.filter(logo=>logo.confidence > 0.7)
                                         .map(logo=>(
                                            {
                                                label:logo.description,
                                                confidence:logo.confidence
                                            }
                                         ));
    
    return{
        labels,
        objects,
        logos
    }

}
