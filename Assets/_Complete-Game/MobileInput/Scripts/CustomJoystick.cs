using UnityEngine;
using UnityEngine.EventSystems;

namespace UnityStandardAssets.CrossPlatformInput
{
    public class CustomJoystick : MonoBehaviour, IPointerDownHandler, IPointerUpHandler, IDragHandler
    {

        [Header("最大移动距离")]
        public int maxMoveDistance = 100;

        public string horizontalAxisName = "Horizontal";
        public string verticalAxisName = "Vertical";
        //摇杆移动位置
        private Vector3 moveToPosition;
        //摇杆初始位置
        private Vector3 stickOriginPosition;
        //摇杆移动距离
        private float distanceOriginToDrag;
        private RectTransform TouchAtlas;
        [SerializeField]
        [Header("摇杆位移比例")]
        private Vector2 deltaPosition;
        public CrossPlatformInputManager.VirtualAxis virtualAxisHorizontal;
        public CrossPlatformInputManager.VirtualAxis virtualAxisVertical;

        // Use this for initialization
        void Start()
        {

            TouchAtlas = transform.GetComponent<RectTransform>();
            stickOriginPosition = TouchAtlas.anchoredPosition3D;

            if (CrossPlatformInputManager.AxisExists(horizontalAxisName))
            {
                CrossPlatformInputManager.UnRegisterVirtualAxis(horizontalAxisName);
            }
            virtualAxisHorizontal = new CrossPlatformInputManager.VirtualAxis(horizontalAxisName);
            CrossPlatformInputManager.RegisterVirtualAxis(virtualAxisHorizontal);

            if (CrossPlatformInputManager.AxisExists(verticalAxisName))
            {
                CrossPlatformInputManager.UnRegisterVirtualAxis(verticalAxisName);
            }
            virtualAxisVertical = new CrossPlatformInputManager.VirtualAxis(verticalAxisName);
            CrossPlatformInputManager.RegisterVirtualAxis(virtualAxisVertical);

        }

        void Update()
        {
            distanceOriginToDrag = Vector3.Distance(TouchAtlas.anchoredPosition3D, stickOriginPosition);
            if (distanceOriginToDrag >= maxMoveDistance)
            {
                moveToPosition = stickOriginPosition + (TouchAtlas.anchoredPosition3D - stickOriginPosition) * maxMoveDistance / distanceOriginToDrag;
                TouchAtlas.anchoredPosition3D = moveToPosition;
            }
        }

        public void OnDrag(PointerEventData eventData)
        {

            TouchAtlas.anchoredPosition += eventData.delta * 2;

            deltaPosition.x = (TouchAtlas.anchoredPosition3D.x - stickOriginPosition.x) / maxMoveDistance;
            deltaPosition.y = (TouchAtlas.anchoredPosition3D.y - stickOriginPosition.y) / maxMoveDistance;
            UpdateVirtualAxes(deltaPosition);
        }

        public void OnPointerDown(PointerEventData eventData)
        {
        }

        public void OnPointerUp(PointerEventData eventData)
        {
            UpdateVirtualAxes(Vector2.zero);
            TouchAtlas.anchoredPosition3D = stickOriginPosition;
        }

        void UpdateVirtualAxes(Vector2 value)
        {
            virtualAxisHorizontal.Update(value.x);
            virtualAxisVertical.Update(value.y);
        }
    }
}