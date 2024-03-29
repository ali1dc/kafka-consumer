#!/usr/bin/env groovy

node {
  stage('Commit') {

    sh('rm -rf ./*')
    properties([
      disableConcurrentBuilds(),
      pipelineTriggers([pollSCM('* * * * *')]),
    ])

    checkout scm
    rvm '2.5.3'
  }

  stage('Code Analysis') {
    rake 'rubocop'
  }

  stage('Build App') {
    rake 'assemble'
  }

  stage('Build') {
    rake 'build:ecs'
  }

  stage('Deployment - RDS') {
    rake 'deploy:rds'
  }

  stage('Deployment - ECS') {
    rake 'deploy:ecs'
  }
}

// Helper function for rake

def rvm(String version) {
  sh returnStdout: false, script: """#!/bin/bash --login
    source /usr/share/rvm/scripts/rvm && \
      rvm use --install --create ${version} && \
      export | egrep -i "(ruby|rvm)" > rvm.env
    rvm use default ${version}
    rvm alias create default ruby-${version}

    which bundle || gem install bundler -v 1.17.3
    bundle install
  """
}

def rake(String task) {
  sh returnStdout: false, script: """#!/bin/bash --login
    set +x
    . rvm.env
    set -x
    bundle exec rake ${task}
  """
}
