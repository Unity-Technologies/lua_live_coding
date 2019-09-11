using System;

public class ObjectSingleton<T>
    where T : class
{
    private static T instance;

    public static T Instance
    {
        get
        {
            if (instance == null)
            {
                instance = CreateInstanceOfT();
            }

            return instance;
        }
    }

    private static T CreateInstanceOfT()
    {
        return Activator.CreateInstance(typeof(T), true) as T;
    }
}