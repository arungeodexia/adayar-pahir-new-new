package com.geodexia.aci

import android.os.Bundle
import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import io.flutter.plugins.GeneratedPluginRegistrant
import io.flutter.plugin.common.MethodChannel
import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

import android.database.Cursor
import android.net.Uri
import android.provider.ContactsContract
import android.app.Activity
import android.util.Log


import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import java.io.InputStream
import java.io.IOException;
import android.content.ContentUris;
import java.io.FileNotFoundException;
import android.provider.MediaStore;

class MainActivity: FlutterActivity()  {
    //var mResult: MethodChannel.Result?;
    private lateinit var mResult: MethodChannel.Result
    private val CHANNEL = "samples.flutter.dev/contactDetails"
    var contactDetails: String ? = "";
//    companion object {
//        // static count
//        var contactDetails: String = "";
//
//        // ataticgetCount()
//        fun getContactDetails(): String? {
//            print("contactDetails ===>" + contactDetails)
//            return contactDetails;
//
//        }
//    }

    private val REQUEST_CODE = 1

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "getContactFromNative") {
                mResult = result;
                //  getContactList();
                val intent = Intent(Intent.ACTION_PICK, ContactsContract.Contacts.CONTENT_URI)
                startActivityForResult(intent, 1)
            } else {
                result.notImplemented()
            }


        }
    }

    public override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?){
        super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == 1 && resultCode == Activity.RESULT_OK && data != null) {
            val contactData = data.data
            val c = contentResolver.query(contactData!!, null, null, null, null)
            if (c!!.moveToFirst()) {

                var phoneNumber = ""
                var phoneNumberFinal = ""
                var emailAddress = ""
                val name = c.getString(c.getColumnIndex(ContactsContract.Contacts.DISPLAY_NAME))
                val contactId = c.getString(c.getColumnIndex(ContactsContract.Contacts._ID))
                var hasPhone = c.getString(c.getColumnIndex(ContactsContract.Contacts.HAS_PHONE_NUMBER))


                //getDiffMobileNo(c,name);
                if (hasPhone.equals("1", ignoreCase = true))
                    hasPhone = "true"
                else
                    hasPhone = "false"

                if (java.lang.Boolean.parseBoolean(hasPhone)) {
                    val phones = contentResolver.query(ContactsContract.CommonDataKinds.Phone.CONTENT_URI, null, ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = " + contactId, null, null)
                    val phoneArrlist = ArrayList<String>()
                    while (phones!!.moveToNext()) {
                        phoneNumber = phones.getString(phones.getColumnIndex(ContactsContract.CommonDataKinds.Phone.NUMBER))
                        phoneArrlist.add(phoneNumber.replace("\\s+".toRegex(), ""));
                        Log.e("Android Native Contacts phoneNumber:==>", "phoneNumber : $phoneNumber")
                    }
                    Log.e("Android Native Contacts phone Numbers :==>", "without space :"+phoneNumber.replace("\\s+".toRegex(), ""))
                    System.out.println(phoneNumber);
                    Log.e("Android Native Contacts:==>", "phones.getCount() :"+ phones.getCount())
                    Log.e("Android Native Contacts Arrlist ","size:==>"+phoneArrlist.size)
                    var finalPhoneArrList = phoneArrlist.distinct()
                    for (item in finalPhoneArrList) {
                        Log.e("ArrList item :==>", "item : $item")
                        if(phoneNumberFinal.equals("")){
                            phoneNumberFinal = item
                        }else {
                            phoneNumberFinal = phoneNumberFinal + "," + item
                        }
                    }
                    Log.e("Android Native Contacts:==>", "phoneNumberFinal :"+ phoneNumberFinal)

                    phones.close()

                }

                // Find Email Addresses
                val emails = contentResolver.query(ContactsContract.CommonDataKinds.Email.CONTENT_URI, null, ContactsContract.CommonDataKinds.Email.CONTACT_ID + " = " + contactId, null, null)
                while (emails!!.moveToNext()) {
                    emailAddress = emails.getString(emails.getColumnIndex(ContactsContract.CommonDataKinds.Email.DATA))
                }
                emails.close()




                Log.e("Android Native Contacts :==>", "Name : $name ,number : $phoneNumber ,mail : $emailAddress")
                var tempContactDetails = "$name%$emailAddress%$phoneNumberFinal"
                contactDetails = tempContactDetails


                ///////////////////New Code Start//////////////
//                try {
//                    var phoneUriFinal:String? = null;
//                    val phoneUri = contentResolver.query(ContactsContract.CommonDataKinds.Phone.PHOTO_URI, null, ContactsContract.CommonDataKinds.Phone.CONTACT_ID + " = " + contactId, null, null)
//                    while (phoneUri!!.moveToNext()) {
//                         phoneUriFinal = phoneUri.getString(phoneUri.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_URI))
//                        Log.e("phoneUri :==>", "phoneUri : $phoneUriFinal")
//                    }
//
//                    if (phoneUriFinal != null) {
//                        Log.e("Android Native Contacts phoneUri :==>", "image_uri : $phoneUriFinal")
//                        try {
//                            var photo: Bitmap? = MediaStore.Images.Media.getBitmap(this.getContentResolver(), Uri.parse(phoneUriFinal))
//                            Log.d("TAG", "\tPHOTO: $photo")
//                        } catch (e: FileNotFoundException) {
//                            e.printStackTrace()
//                        } catch (e: IOException) {
//                            e.printStackTrace()
//                        }
//                    }
//                /*val uriCursor : Cursor ? = c.getColumnIndex(ContactsContract.CommonDataKinds.Phone.PHOTO_URI);
//                    if(uriCursor!= null ){
//                        val image_uri: String = c.getString(uriCursor)
//
//                        if (image_uri != null) {
//                            Log.e("Android Native Contacts image_uri :==>", "image_uri : $image_uri")
//                            try {
//                                var photo: Bitmap? = MediaStore.Images.Media.getBitmap(this.getContentResolver(), Uri.parse(image_uri))
//                                Log.d("TAG", "\tPHOTO: $photo")
//                            } catch (e: FileNotFoundException) {
//                                e.printStackTrace()
//                            } catch (e: IOException) {
//                                e.printStackTrace()
//                            }
//                        }
//                    }*/
//
//                }catch (e: IOException) {
//                    e.printStackTrace()
//                }


//                var photo: Bitmap = BitmapFactory.decodeResource(context.getResources(),
//                        R.mipmap.ic_launcher)
//
//                try {
//                    val inputStream: InputStream = ContactsContract.Contacts.openContactPhotoInputStream(getContentResolver(),
//                            ContentUris.withAppendedId(ContactsContract.Contacts.CONTENT_URI, Long(contactId)))
//                    if (inputStream != null) {
//                        photo = BitmapFactory.decodeStream(inputStream)
//                        Log.e("Selected Photo ",":==>"+photo);
//                    }
//                    assert(inputStream != null)
//                    inputStream.close()
//                } catch (e: IOException) {
//                    e.printStackTrace()
//                }

                ///////////////New Code End ///////////////////


                if(mResult != null){
                    if (contactDetails != null && !contactDetails.equals("")) {
                        mResult.success(contactDetails)
                    } else {
                        mResult.error("UNAVAILABLE", "UNAVAILABLE Contact Details.", null)
                    }
                }

            }
            c.close()
        }else {
            Log.e("onActivity result :==>", "from other request code : " + requestCode)
        }

    }
}
