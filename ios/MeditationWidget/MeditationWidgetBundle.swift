//
//  MeditationWidgetBundle.swift
//  MeditationWidget
//

import WidgetKit
import SwiftUI

@main
struct MeditationWidgetBundle: WidgetBundle {
    var body: some Widget {
        Meditation1HWidget()       // default (first in list = shown by default in picker)
        Meditation15mWidget()
        Meditation30mWidget()
        Meditation1_5HWidget()
        Meditation2HWidget()
        Meditation2_5HWidget()
        Meditation3HWidget()
        Meditation3_5HWidget()
        Meditation4HWidget()
        MeditationEndAtWidget()
        MeditationUnlimitedWidget()
    }
}