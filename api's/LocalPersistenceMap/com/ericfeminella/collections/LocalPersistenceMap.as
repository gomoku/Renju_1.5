/*
 Copyright (c) 2008 Eric J. Feminella <eric@ericfeminella.com>
 All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy 
 of this software and associated documentation files (the "Software"), to deal 
 in the Software without restriction, including without limitation the rights 
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished 
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all 
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
 PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

 @internal
 */

package com.ericfeminella.collections
{
    import flash.net.ObjectEncoding;
    import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;
    
    /**
     * 
     * Provides an <code>IMap</code> implementation into the <code>data</code> 
     * object of a <code>SharedObject</code> on a clients local file system.
     * 
     * <p>
     * <code>LocalPersistenceMap</code> allows the <code>data</code> object 
     * of a <code>SharedObject</code> to be accessed via an <code>IMap</code>
     * implementation in order to provide a consistant API for working with
     * the underlying data of the <code>SharedObject</code>.
     * </p>
     * 
     * @example The following example demonstrates how a client implementation
     * of <code>LocalPersistenceMap</code> can be utilized to provide a typical
     * <code>IMap</code> implementation into a <code>SharedObject</code>.
     * 
     * <listing version="3.0">
     * 
     * var map:IMap = new LocalPersistenceMap("test", "/");
     * map.put("username", "efeminella");
     * map.put("password", "43kj5k4nr43r934hcr34hr8h3");
     * map.put("admin", true);
     * 
     * </listing>
     * 
     * @see com.ericfeminella.collections.IMap
     * @see flash.net.SharedObject;
     * 
     */    
    public class LocalPersistenceMap implements IMap
    {
        /**
         *
         * Defines the underlying <code>SharedObject</code> instance in which 
         * the persistant <code>data</code> is stored.
         * 
         */        
        protected var sharedObject:SharedObject;
        
        /**
         *
         * Defines the minimum disc space which is required by the persistant
         * <code>SharedObject</code>.
         * 
         */    
        protected var minimumStorage:Number;
        
        /**
         * 
         * <ocde>LocalPersistenceMap</code> constructor creates a reference to 
         * the persisted <code>SharedObject</code> available from the clients 
         * local disk. If the <code>SharedObject</code> does not currently exist, 
         * Flash Player will attempt to created it.
         * 
         * <p>
         * If the identifier parameter contains any invalid charachters, they will 
         * be substituted with underscores
         * </p>
         * 
         * @param  name of the local <code>SharedObject</code>
         * @param  the local path to the <code>SharedObject</code>
         * @param  specifies if the shared object is from a secure domain
         * @param  minimum amount of disc space required by the shared object
         * 
         * @return true if the write operation was successful, false if not
         * 
         */
        public function LocalPersistenceMap(identifier:String, localPath:String = null, secure:Boolean = false, minimumStorage:int = 500)
        {

            sharedObject = SharedObject.getLocal( stripInvalidChars( identifier ), localPath, secure );
            sharedObject.objectEncoding = ObjectEncoding.AMF3;
            sharedObject.flush( minimumStorage );
            
            this.minimumStorage = minimumStorage;
        }

        /**
         *
         * Adds a key and value to the <code>data</code> object of the 
         * underlying the <code>SharedObject</code> instance.
         * 
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "user", userVO );
         *
         * </listing>
         *
         * @param the key to add to the map
         * @param the value of the specified key
         *
         */
        public function put(key:*, value:*) : void
        {
            sharedObject.data[key] = value;
            sharedObject.flush( minimumStorage );
        }
        
        /**
         * 
         * Removes a key and value from the <code>data</code> object of the 
         * underlying the <code>SharedObject</code> instance.
         * 
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         * map.remove( "admin" );
         *
         * </listing>
         *
         * @param the key to remove from the map
         *
         */
        public function remove(key:*) : void
        {
            delete sharedObject.data[key];
            sharedObject.flush( minimumStorage );
        }

        /**
         *
         * Determines if a key exists in the <code>data</code> object of the 
         * underlying the <code>SharedObject</code> instance.
         * 
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         *
         * trace( map.containsKey( "admin" ) ); //true
         *
         * </listing>
         *
         * @param  the key in which to determine existance in the map
         * @return true if the key exisits, false if not
         *
         */    
        public function containsKey(key:*) : Boolean
        {
            return sharedObject.data[key] != undefined;
        }

        /**
         *
         * Determines if a value exists in the HashMap instance
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         *
         * trace( map.containsValue( adminVO ) ); //true
         *
         * </listing>
         *
         * @param  the value in which to determine existance in the map
         * @return true if the value exisits, false if not
         *
         */
        public function containsValue(value:*) : Boolean
        {
            var result:Boolean = false;
            
            for ( var prop:String in sharedObject.data )
            {
                if (sharedObject.data[prop] == value)
                {
                    result = true;
                    break;
                }
            }
            return result;
        }

        /**
         *
         * Returns a key value from the HashMap instance
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         *
         * trace( map.getKey( adminVO ) ); //admin
         *
         * </listing>
         *
         * @param  the key in which to retrieve the value of
         * @return the value of the specified key
         *
         */
        public function getKey(value:*) : String
        {
            var key:String = "";

            for ( var prop:String in sharedObject.data )
            {
                if (sharedObject.data[prop] == value)
                {
                    key = prop;
                    break;
                }
            }
            return key;
        }

        /**
         *
         * Returns each key added to the <code>data</code> object of the 
         * underlying the <code>SharedObject</code> instance.
         * 
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         * map.put( "editor", editorVO );
         *
         * trace( map.getKeys() ); //admin, editor
         *
         * </listing>
         *
         * @return Array of key identifiers
         *
         */
        public function getValue(key:*) : *
        {
            var value:*;

            for ( var prop:String in sharedObject.data )
            {
                if (prop == key)
                {
                    value = sharedObject.data[prop];
                    break;
                }
            }
            return value;
        }

        /**
         *
         * Returns each key added to the <code>data</code> object of the 
         * underlying the <code>SharedObject</code> instance.
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         * map.put( "editor", editorVO );
         *
         * trace( map.getKeys() ); //admin, editor
         *
         * </listing>
         *
         * @return Array of key identifiers
         *
         */
        public function getKeys() : Array
        {
            var keys:Array = new Array();

            for ( var prop:String in sharedObject.data )
            {
                keys.push( prop );
            }
            return keys;
        }

        /**
         *
         * Retrieves each value assigned to the <code>data</code> object of 
         * the underlying the <code>SharedObject</code> instance.
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         * map.put( "editor", editorVO );
         *
         * trace( map.getValues() ); //[object, adminVO],[object, editorVO]
         *
         * </listing>
         *
         * @return Array of values assigned for all keys in the map
         *
         */
        public function getValues() : Array
        {
            var values:Array = new Array();

            for ( var prop:String in sharedObject.data )
            {
                values.push( sharedObject.data[prop] );
            }
            return values;
        }

        /**
         *
         * Determines the size of the <code>data</code> object of the 
         * underlying the <code>SharedObject</code> instance.e
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         * map.put( "editor", editorVO );
         *
         * trace( map.size() ); //2
         *
         * </listing>
         *
         * @return the current size of the map instance
         *
         */
        public function size() : int
        {
            var length:int = 0;

            for ( var key:* in sharedObject.data )
            {
                length++;
            }
            return length;
        }
        
        /**
         *
         * Determines if the current <code>data</code> object of the 
         * underlying the <code>SharedObject</code> instance is empty.
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * trace( map.isEmpty() ); //true
         *
         * map.put( "admin", adminVO );
         * trace( map.isEmpty() ); //false
         *
         * </listing>
         *
         * @return true if the current map is empty, false if not
         *
         */
        public function isEmpty() : Boolean
        {
            return size() <= 0;
        }
       
        /**
         *
         * Resets all key / value assignment in the <code>data</code> object 
         * of the underlying the <code>SharedObject</code> instance is empty 
         * to null.
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         * map.put( "editor", editorVO );
         * map.reset();
         *
         * trace( map.getValues() ); //null, null
         *
         * </listing>
         *
         */
        public function reset() : void
        {
            for ( var prop:String in sharedObject.data )
            {
                sharedObject.data[prop] = null;
            }
            sharedObject.flush( minimumStorage );
        }
        
        /**
         * 
         * Resets all key / values defined in the <code>data</code> object of 
         * the underlying the <code>SharedObject</code> instance is empty to 
         * null with the exception of the specified key.
         *
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         * map.put( "editor", editorVO );
         *
         * trace( map.getValues() ); //[object, adminVO],[object, editorVO]
         *
         * map.resetAllExcept( "editor", editorVO );
         * trace( map.getValues() ); //null, [object, editorVO]
         *
         * </listing>
         *
         * @param the key which is not to be cleared from the map
         *
         */    
        public function resetAllExcept(key:*) : void
        {
            for ( var prop:String in sharedObject.data )
            {
                if ( prop != key )
                {
                    sharedObject.data[prop] = null;
                }
            }
            sharedObject.flush( minimumStorage );
        }

        /**
         *
         * Resets all key / values in the <code>data</code> object of the 
         * underlying the <code>SharedObject</code> instance  to null.
         *
         * @example
         * 
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         * map.put( "editor", editorVO );
         * 
         * trace( map.size() ); //2
         *
         * map.clear();
         * 
         * trace( map.size() ); //0
         *
         * </listing>
         *
         */
        public function clear() : void
        {
            for ( var key:* in sharedObject.data )
            {
                remove( key );
            }
            sharedObject.flush( minimumStorage );
        }
              
        /**
         * 
         * Clears all key / values defined in the <code>data</code> object 
         * of the underlying the <code>SharedObject</code> instance with the 
         * exception of the specified key.
         * 
         * @example
         * 
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:IMap = new LocalPersistenceMap("sharedObjectName");
         * map.put( "admin", adminVO );
         * map.put( "editor", editorVO );
         * trace( map.size() ); //2
         *
         * map.clearAllExcept( "editor", editorVO );
         * trace( map.getValues() ); //[object, editorVO]
         * trace( map.size() ); //1
         *
         * </listing>
         *
         * @param the key which is not to be cleared from the map
         *
         */
        public function clearAllExcept(key:*) : void
        {
            for ( var prop:String in sharedObject.data )
            {
                if ( prop != key )
                {
                    delete sharedObject.data[prop];
                }
            }
            sharedObject.flush( minimumStorage );
        }
        
        /**
         * 
         * Retrieves the underlying <code>SharedObject</code> instance
         * used by the <code>LocalPersistenceMap</code>.
         * 
         * @example
         * <listing version="3.0">
         *
         * import com.ericfeminella.collections.LocalPersistenceMap;
         * import com.ericfeminella.collections.IMap;
         *
         * var map:LocalPersistenceMap = new LocalPersistenceMap("sharedObjectName");
         * trace( map.sharedObjectInstance );
         *
         * </listing>
         * 
         * @return underlying <code>SharedObject</code> instance
         * 
         */        
        public function get sharedObjectInstance() : SharedObject
        {
            return sharedObject;
        }
        
        /**
         * 
         * Removes invalid charachters from a <code>SharedObject</code> name
         * and substitutes the invalid charachters with an underscore.
         * 
         * @return a valid <code>SharedObject</code> name
         * 
         */    
        protected static function stripInvalidChars(identifier:String) : String
        {
            var pattern:RegExp = /[~%&\;:\"\'<>\?#]/g;
            return identifier.replace(pattern, "_");
        }
    }
}
