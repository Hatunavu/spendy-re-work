#!groovy

def shouldBuild = false
def commitContainsSkip = ""

echo "Welcome to Jenkins, this is Spendy project."

pipeline {
  agent {
    node {
      label "acazia-imac-2017"
    }
  }

  options {
    ansiColor("xterm")
  }

  stages {
    stage('GIT LOG LATEST COMMIT MESSAGE') {
            steps {
                sh '''
                git log -n 1 >> android/releasenotes.txt
                '''
		script {
                	def content = readFile(file: 'android/releasenotes.txt')
		        }
	        }
        }

    stage("Init") {
      steps {
        echo "Initialization"
        sh '''
        #!/bin/bash
        export PATH=$PATH:/usr/local/bin:$HOME/.rbenv/bin:$HOME/.rbenv/shims
        export MATCH_PASSWORD=spendy
        export FASTLANE_APPLE_APPLICATION_SPECIFIC_PASSWORD=hqpt-nhix-rnru-tnbq
        rbenv rehash

        export NVM_DIR="$HOME/.nvm"
        bash $NVM_DIR/nvm.sh
        '''

        script {
          lastCommitInfo = sh(script: "git log -1", returnStdout: true).trim()
          commitContainsSkip = sh(script: "git log -1 | grep '.*\\[skip ci\\].*'", returnStatus: true)

          if (commitContainsSkip == 0) {
            skippingText = "Skipping commit."
            env.shouldBuild = false
            currentBuild.result = "NOT_BUILT"
          }
        }
      }
    }

    stage('Clear env file') {
      steps {
        sh '''#!/bin/bash
        ~/Projects/Flutter2/bin/flutter clean
	      ~/Projects/Flutter2/bin/flutter pub get
	      ~/Projects/Flutter2/bin/flutter doctor
        '''
      }
    }

     stage("Build and upload Android to firebase distribution") {
       steps {
         sh '''#!/bin/bash
  	  ~/Projects/Flutter2/bin/flutter build apk --release
          cd android
          gradle appDistributionUploadRelease
         '''
       }
     }

    stage("Build and upload iOS to TestFlight") {
      steps {
        sh '''#!/bin/bash
        ~/Projects/Flutter2/bin/flutter clean
        ~/Projects/Flutter2/bin/flutter pub get
        cd ios
        pod install
        fastlane beta
        '''
      }
    }
  }

  post {
    always {
      sh '''#!/bin/bash
      rm -rf android/releasenotes.txt
      rm -rf ios/fastlane/delivery
      rm -rf android/build
	git reset --hard
        '''
    }
    failure {
       sh '''
            echo "Build failed."
            git reset --hard
            '''
    }
    unstable {
      echo "Process unstable. Please try again."
    }
  }
}
