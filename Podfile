# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

def import_pods
  pod 'Firebase/Core'
  pod 'Firebase/Messaging'
  pod 'Firebase/RemoteConfig'
  pod 'Firebase/Database'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Functions'
  pod 'Firebase/InAppMessagingDisplay'
  pod 'Firebase/MLVision'
  pod 'Firebase/MLVisionFaceModel'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SVProgressHUD'
  pod 'Nuke'
  pod 'Alamofire'
  pod 'Hero'
end

target 'firebase_hackathon' do
  use_frameworks!

  import_pods

  target 'firebase_hackathonTests' do
    inherit! :search_paths
  end

  target 'firebase_hackathonUITests' do
    inherit! :search_paths
  end

end
