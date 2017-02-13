// Grab_CameraEvents_Usb.cpp
/*
    Note: Before getting started, Basler recommends reading the Programmer's Guide topic
    in the pylon C++ API documentation that gets installed with pylon.
    If you are upgrading to a higher major version of pylon, Basler also
    strongly recommends reading the Migration topic in the pylon C++ API documentation.

    Basler USB3 Vision cameras can send event messages. For example, when a sensor
    exposure has finished, the camera can send an Exposure End event to the PC. The event
    can be received by the PC before the image data for the finished exposure has been completely
    transferred. This sample illustrates how to be notified when camera event message data
    is received.

    The event messages are automatically retrieved and processed by the InstantCamera classes.
    The information carried by event messages is exposed as parameter nodes in the camera node map
    and can be accessed like "normal" camera parameters. These nodes are updated
    when a camera event is received. You can register camera event handler objects that are
    triggered when event data has been received.

    These mechanisms are demonstrated for the Exposure End event.
    The  Exposure End event carries the following information:
    * EventExposureEndFrameID: Indicates the number of the image frame that has been exposed.
    * EventExposureEndTimestamp: Indicates the moment when the event has been generated.
    transfer the exposed frame.

    It is shown in this sample how to register event handlers indicating the arrival of events
    sent by the camera. For demonstration purposes, several different handlers are registered
    for the same event.
*/


// Include files to use the PYLON API.
#include <pylon/PylonIncludes.h>
// add changes
// Include files used by samples.
#include "../include/ConfigurationEventPrinter.h"
#include "../include/CameraEventPrinter.h"

// Namespace for using pylon objects.
using namespace Pylon;
#define USE_USB 1
#if defined( USE_USB )
// Settings for using Basler USB cameras.
#include <pylon/usb/BaslerUsbInstantCamera.h>
typedef Pylon::CBaslerUsbInstantCamera Camera_t;
typedef CBaslerUsbCameraEventHandler CameraEventHandler_t; // Or use Camera_t::CameraEventHandler_t
using namespace Basler_UsbCameraParams;
#else
#error Camera type is not specified. For example, define USE_USB for using USB cameras.
#endif

// Namespace for using cout.
using namespace std;

//Enumeration used for distinguishing different events.
enum MyEvents
{
    eMyExposureEndEvent  = 100
    // More events can be added here.
};

// Number of images to be grabbed.
static const uint32_t c_countOfImagesToGrab = 5;


// Example handler for camera events.
class CSampleCameraEventHandler : public CameraEventHandler_t
{
public:
    // Only very short processing tasks should be performed by this method. Otherwise, the event notification will block the
    // processing of images.
    virtual void OnCameraEvent( Camera_t& camera, intptr_t userProvidedId, GenApi::INode* /* pNode */)
    {
        std::cout << std::endl;
        switch ( userProvidedId )
        {
        case eMyExposureEndEvent: // Exposure End event
            cout << "Exposure End event. FrameID: " << camera.EventExposureEndFrameID.GetValue() << " Timestamp: " << camera.EventExposureEndTimestamp.GetValue() << std::endl << std::endl;
            break;
        // More events can be added here.
        }
    }
};

//Example of an image event handler.
class CSampleImageEventHandler : public CImageEventHandler
{
public:
    virtual void OnImageGrabbed( CInstantCamera& camera, const CGrabResultPtr& ptrGrabResult)
    {
        cout << "CSampleImageEventHandler::OnImageGrabbed called." << std::endl;
        cout << std::endl;
        cout << std::endl;
    }
};

int main(int argc, char* argv[])
{
    // The exit code of the sample application
    int exitCode = 0;

    // Before using any pylon methods, the pylon runtime must be initialized. 
    PylonInitialize();

    // Create an example event handler. In the present case, we use one single camera handler for handling multiple camera events.
    // The handler prints a message for each received event.
    CSampleCameraEventHandler* pHandler1 = new CSampleCameraEventHandler;

    // Create another more generic event handler printing out information about the node for which an event callback
    // is fired.
    CCameraEventPrinter*  pHandler2 = new CCameraEventPrinter;

    try
    {
        // Only look for cameras supported by Camera_t
        CDeviceInfo info;
        info.SetDeviceClass( Camera_t::DeviceClass());

        // Create an instant camera object with the first found camera device matching the specified device class.
        Camera_t camera( CTlFactory::GetInstance().CreateFirstDevice(info));

		// Open the camera for setting parameters.
		camera.Open();

		// Set the acquisition mode to single frame
		camera.AcquisitionMode.SetValue(AcquisitionMode_Continuous);
		// Select the frame burst start trigger
		camera.TriggerSelector.SetIntValue(TriggerSelector_FrameBurstStart);
		// Set the mode for the selected trigger
		camera.TriggerMode.SetValue(TriggerMode_Off);
		// Disable the acquisition frame rate parameter (this will disable the camera¡¯s
		// internal frame rate control and allow you to control the frame rate with
		// software frame start trigger signals)
		camera.AcquisitionFrameRateEnable.SetValue(false);
		// Select the frame start trigger
		camera.TriggerSelector.SetValue(TriggerSelector_FrameStart);
		// Set the mode for the selected trigger
		camera.TriggerMode.SetValue(TriggerMode_On);
		// Set the source for the selected trigger
		camera.TriggerSource.SetValue(TriggerSource_Software);
		// Set for the timed exposure mode
		camera.ExposureMode.SetValue(ExposureMode_Timed);
		// Set the exposure time
		camera.ExposureTime.SetValue(3000.0);
		// Execute an acquisition start command to prepare for frame acquisition


		

		

		
		// Start the grabbing of c_countOfImagesToGrab images.
		camera.StartGrabbing(c_countOfImagesToGrab);

		// This smart pointer will receive the grab result data.
		CGrabResultPtr ptrGrabResult;

		camera.AcquisitionStart.Execute();
		for (int i = 0; i<c_countOfImagesToGrab; i++)
		{
			// Execute a Trigger Software command to apply a frame start
			// trigger signal to the camera
			// Execute the software trigger. Wait up to 1000 ms for the camera to be ready for trigger.		
			if (camera.WaitForFrameTriggerReady(1000, TimeoutHandling_ThrowException))
			{
				camera.ExecuteSoftwareTrigger();
			}

			
			// Retrieve acquired frame here
			camera.RetrieveResult(5000, ptrGrabResult, TimeoutHandling_ThrowException);
			// Nothing to do here with the grab result, the grab results are handled by the registered event handler.
		}
		camera.AcquisitionStop.Execute();
		// Note: as long as the Trigger Selector is set to FrameStart, executing
		// a Trigger Software command will apply a software frame start trigger
		// signal to the camera


    
    }
    catch (const GenericException &e)
    {
        // Error handling.
        cerr << "An exception occurred." << endl
        << e.GetDescription() << endl;
        exitCode = 1;
    }


    // Comment the following two lines to disable waiting on exit.
    cerr << endl << "Press Enter to exit." << endl;
    while( cin.get() != '\n');

    // Releases all pylon resources. 
    PylonTerminate(); 

    return exitCode;
}

