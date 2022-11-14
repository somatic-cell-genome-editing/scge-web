package edu.mcw.scge.service;

public class StringUtils {

    public static String encode( String s )
    {
        if( s == null || s.length() == 0 )
            return s;

        StringBuilder       sb = new StringBuilder( s );
        for( int i=0 ; i < sb.length() ; i++ )
        {
            char        c = sb.charAt( i );
            if     ( c == '&'  ) { sb.replace( i, i+1, "&amp;"  ); i+=4; }
            else if( c == '"'  ) { sb.replace( i, i+1, "&quot;" ); i+=5; }
            else if( c == '\'' ) { sb.replace( i, i+1, "&apos;" ); i+=5; }
            else if( c == '>'  ) { sb.replace( i, i+1, "&gt;"   ); i+=3; }
            else if( c == '<'  ) { sb.replace( i, i+1, "&lt;"   ); i+=3; }
        }

        return sb.toString();
    }
    public static String capitalizeFirst( String s )
    {
        if( s == null || s.length() == 0 )
            return s;
        else


        return org.apache.commons.lang3.StringUtils.capitalize(s);
    }
}

