import {onSchedule} from 'firebase-functions/scheduler'
import { allUsersExpiryReminder } from './AllUsersExpiryReminder.js'

export const scheduleUsersExpiryReminder =onSchedule({
    schedule:"0 14 * * *",
    region:"Asia/Kuala_Lumpur",
    memory:"256MiB",
    timeoutSeconds:120,},
    async (event) => {
        try{
            await allUsersExpiryReminder()
            console.log("Successfully sent expiry reminder to users.")
        } 
        catch(err){
            console.error("Failed to send expiry reminder to users." ,err.message)
        }    
    }
)