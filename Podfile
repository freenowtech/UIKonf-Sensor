platform :ios, '10.3'

use_frameworks!
inhibit_all_warnings!

def shared_pods
  pod 'SnapKit', '~> 5.0'
  pod 'UITextView+Placeholder', '~> 1.2'
  pod 'RxSwift', '~> 5.0'
  pod 'RxCocoa', '~> 5.0'
  pod 'SDWebImage/Core', '~> 4.4'
end

target "UIKonfExercise" do
  shared_pods
end

target "SharedKit" do
  shared_pods
end

target "PassengerRating" do
  shared_pods
  pod 'Sensor'

  target "PassengerRatingTests" do
    inherit! :search_paths
  	pod 'SensorTest'
  end
end