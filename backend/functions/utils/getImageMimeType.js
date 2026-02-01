
export default function getImageMimeType(imageUri){
    const match = imageUri.match(/\.(\w+)$/);
    if(!match){
        return ""
    }

    const extenstion = match[1].toLowerCase()
    switch(extenstion){
        case "jpg":
        case "jpeg":
            return 'image/jpeg';
        case "png":
            return 'image/png'
        default:
            return ""
    }
}