import admin from './firebase-admin.cjs'

export async function getAllUsersData(){
    const database = admin.firestore()
    try{
        const usersSnapShot = await database.collection('users').get()

        if(usersSnapShot.empty){
            return{
                success:false,
                message:"No user found",
                data:[]
            }
        }

        const usersData = usersSnapShot.docs.map(doc=>({
            userId:doc.id,
            ...doc.data()
        }))

        return{
            success:true,
            message:"Successfully retrieved users data",
            data:usersData
        }
    }
    catch(err){
        throw new Error("Failed to retrieved users' data" , {cause:err})
    }


}