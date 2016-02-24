/**
 * Created by alekseykabanov on 12.02.16.
 */
package com.nikaent.ane.vk.model {
public class UserParam {
    public static function get all():String{
        return "id,first_name,last_name,sex,bdate,city,country,photo_50,photo_100,"
                + "photo_200_orig,photo_200,photo_400_orig,photo_max,photo_max_orig,online,"
                + "online_mobile,lists,domain,has_mobile,contacts,connections,site,education,"
                + "universities,schools,can_post,can_see_all_posts,can_see_audio,can_write_private_message,"
                + "status,last_seen,common_count,relation,relatives,counters";
    }
}
}
