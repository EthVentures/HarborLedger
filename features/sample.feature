#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

Feature: Permissions Check

    Background:
        Given I have deployed the business network definition ..
        And I have added the following participants of type com.harborledger.network.Refugee
            | participantId   | firstName | lastName |
            | 12345 | Dave     | A        |
            | 67890   | Aleks       | B        |
        And I have added the following assets of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 1       | 12345 | 10    |
            | 2       | 67890   | 20    |
        And I have issued the participant com.harborledger.network.Refugee#12345 with the identity alice1
        And I have issued the participant com.harborledger.network.Refugee#67890 with the identity bob1

    Scenario: Dave can read all of the assets
        When I use the identity alice1
        Then I should have the following assets of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 1       | 12345 | 10    |
            | 2       | 67890   | 20    |

    Scenario: Aleks can read all of the assets
        When I use the identity alice1
        Then I should have the following assets of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 1       | 12345 | 10    |
            | 2       | 67890   | 20    |

    Scenario: Dave can add assets that he owns
        When I use the identity alice1
        And I add the following asset of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 3       | 12345 | 30    |
        Then I should have the following assets of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 3       | 12345 | 30    |

    Scenario: Dave cannot add assets that Aleks owns
        When I use the identity alice1
        And I add the following asset of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 3       | 67890   | 30    |
        Then I should get an error matching /does not have .* access to resource/

    Scenario: Aleks can add assets that he owns
        When I use the identity bob1
        And I add the following asset of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 4       | 67890   | 40    |
        Then I should have the following assets of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 4       | 67890   | 40    |

    Scenario: Aleks cannot add assets that Dave owns
        When I use the identity bob1
        And I add the following asset of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 4       | 12345 | 40    |
        Then I should get an error matching /does not have .* access to resource/

    Scenario: Dave can update his assets
        When I use the identity alice1
        And I update the following asset of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 1       | 12345 | 50    |
        Then I should have the following assets of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 1       | 12345 | 50    |

    Scenario: Dave cannot update Aleks's assets
        When I use the identity alice1
        And I update the following asset of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 2       | 67890   | 50    |
        Then I should get an error matching /does not have .* access to resource/

    Scenario: Aleks can update his assets
        When I use the identity bob1
        And I update the following asset of type com.harborledger.network.BankAccount
            | accountId | owner         | value |
            | 2       | 67890 | 60    |
        Then I should have the following assets of type com.harborledger.network.BankAccount
            | accountId | owner         | value |
            | 2       | 67890 | 60    |

    Scenario: Aleks cannot update Dave's assets
        When I use the identity bob1
        And I update the following asset of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 1       | 12345 | 60    |
        Then I should get an error matching /does not have .* access to resource/

    Scenario: Dave can remove his assets
        When I use the identity alice1
        And I remove the following asset of type com.harborledger.network.BankAccount
            | accountId |
            | 1       |
        Then I should not have the following assets of type com.harborledger.network.BankAccount
            | accountId |
            | 1       |

    Scenario: Dave cannot remove Aleks's assets
        When I use the identity alice1
        And I remove the following asset of type com.harborledger.network.BankAccount
            | accountId |
            | 2       |
        Then I should get an error matching /does not have .* access to resource/

    Scenario: Aleks can remove his assets
        When I use the identity bob1
        And I remove the following asset of type com.harborledger.network.BankAccount
            | accountId |
            | 2       |
        Then I should not have the following assets of type com.harborledger.network.BankAccount
            | accountId |
            | 2       |

    Scenario: Aleks cannot remove Dave's assets
        When I use the identity bob1
        And I remove the following asset of type com.harborledger.network.BankAccount
            | accountId |
            | 1       |
        Then I should get an error matching /does not have .* access to resource/

    Scenario: Dave can submit a transaction for his assets
        When I use the identity alice1
        And I submit the following transaction of type com.harborledger.network.SampleTransaction
            | asset | newValue |
            | 1     | 50       |
        Then I should have the following assets of type com.harborledger.network.BankAccount
            | accountId | owner           | value |
            | 1       | 12345 | 50    |
        And I should have received the following event of type com.harborledger.network.SampleEvent
            | asset   | oldValue | newValue |
            | 1       | 10       | 50       |

    Scenario: Dave cannot submit a transaction for Aleks's assets
        When I use the identity alice1
        And I submit the following transaction of type com.harborledger.network.SampleTransaction
            | asset | newValue |
            | 2     | 50       |
        Then I should get an error matching /does not have .* access to resource/

    Scenario: Aleks can submit a transaction for his assets
        When I use the identity bob1
        And I submit the following transaction of type com.harborledger.network.SampleTransaction
            | asset | newValue |
            | 2     | 60       |
        Then I should have the following assets of type com.harborledger.network.BankAccount
            | accountId | owner         | value |
            | 2       | 67890 | 60    |
        And I should have received the following event of type com.harborledger.network.SampleEvent
            | asset   | oldValue | newValue |
            | 2       | 20       | 60       |

    Scenario: Aleks cannot submit a transaction for Dave's assets
        When I use the identity bob1
        And I submit the following transaction of type com.harborledger.network.SampleTransaction
            | asset | newValue |
            | 1     | 60       |
        Then I should get an error matching /does not have .* access to resource/
