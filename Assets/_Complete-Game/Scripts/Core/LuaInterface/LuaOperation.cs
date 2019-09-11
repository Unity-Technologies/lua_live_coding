using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System;
using XLua;

[CSharpCallLua]
public delegate void VoidEvent();

[LuaCallCSharp]
public class LuaOperation : MonoBehaviour
{
    internal static ILuaBehaviourManager luaBehaviourManager;

    public string classPath = "";

    public event VoidEvent AwakeEvent;
    public event VoidEvent StartEvent;
    public event VoidEvent EnableEvent;
    public event VoidEvent DisableEvent;
    public event VoidEvent DestroyEvent;
    public event VoidEvent UpdateEvent;
    public event VoidEvent FixedUpdateEvent;

    bool awakeAlready = false;
    void Awake()
    {
        AwakeByBehaviour();
    }
    public void AwakeByBehaviour()
    {
        if (!string.IsNullOrEmpty(classPath) && !awakeAlready)
        {
            awakeAlready = true;
            LuaBehaviourManager.Instance.CreateBehaviour(classPath, this.gameObject);

            if (AwakeEvent != null)
            {
                AwakeEvent();
            }
        }
    }

    void Start()
    {
        if (StartEvent != null)
        {
            StartEvent();
        }
    }

    void OnEnable()
    {
        if (EnableEvent != null)
        {
            EnableEvent();
        }
    }

    void OnDisable()
    {
        if (DisableEvent != null)
        {
            DisableEvent();
        }
    }

    void OnDestroy()
    {
        if (DestroyEvent != null)
        {
            DestroyEvent();
        }

        this.Clear();
    }

    void Update()
    {
        if (UpdateEvent != null)
        {
            UpdateEvent();
        }
    }

    void FixedUpdate()
    {
        if (FixedUpdateEvent != null)
        {
            FixedUpdateEvent();
        }
    }

    private void Clear()
    {
        this.AwakeEvent = null;
        this.StartEvent = null;
        this.EnableEvent = null;
        this.DisableEvent = null;
        this.DisableEvent = null;

        this.StopAllCoroutines();
        this.coBodys = null;

#if UNITY_EDITOR
        if (LuaBehaviourManager.Instance != null)
        {
            LuaBehaviourManager.Instance.CleanBehaviourCache(classPath);
        }
#endif
    }

    private Dictionary<object, IEnumerator> coBodys = new Dictionary<object, IEnumerator>();

    public void YieldAndCallback(object to_yield, Action callback)
    {
        var body = CoBody(to_yield, callback);

        coBodys[to_yield] = body;

        StartCoroutine(body);
    }

    public void StopYield(object to_yield)
    {
        if (!coBodys.ContainsKey(to_yield))
        {
            Debug.LogError("No Target to stop");
        }

        this.StopCoroutine(coBodys[to_yield]);
    }

    private IEnumerator CoBody(object to_yield, Action callback)
    {
        if (to_yield is IEnumerator)
        {
            yield return StartCoroutine((IEnumerator)to_yield);
        }
        else
        {
            yield return to_yield;
        }

        callback();
    }
}