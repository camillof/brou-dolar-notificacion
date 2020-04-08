class AsyncJobLog < ApplicationRecord
  enum state:
  {
    scheduled: 0,
    started: 1,
    finished: 2
  }
end
