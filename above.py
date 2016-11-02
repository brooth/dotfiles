
from .base import Base

from deoplete.logger import getLogger
from deoplete.util import parse_buffer_pattern

logger = getLogger('above')


class Source(Base):
    def __init__(self, vim):
        super().__init__(vim)
        self.name = 'above'
        self.mark = '[^]'
        self.rank = 999

    def gather_candidates(self, context):
        line = context['position'][1]
        complete_str = context['complete_str']
        candidates = parse_buffer_pattern(
                        reversed(self.vim.call('getline', max([1, line - 20]), line)),
                        context['keyword_patterns'],
                        context['complete_str'])
        return [{'word': x} for x in candidates if x.startswith(complete_str)]

