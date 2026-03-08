import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/quantum_post.dart';
import '../data/post_repository.dart';
import '../services/progress_service.dart';
import '../theme/app_theme.dart';
import '../components/ambient_particles.dart';
import '../components/post_card.dart';

class DailyFeedScreen extends StatefulWidget {
  const DailyFeedScreen({super.key});

  @override
  State<DailyFeedScreen> createState() => _DailyFeedScreenState();
}

class _DailyFeedScreenState extends State<DailyFeedScreen> {
  PageController? _pageController;
  List<QuantumPost> _posts = [];
  int _currentPage = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIndex = prefs.getInt('daily_feed_index') ?? 0;
    
    final posts = await PostRepository.generateDailyFeed();
    
    if (mounted) {
      setState(() {
        _posts = posts;
        _currentPage = savedIndex < posts.length ? savedIndex : 0;
        _pageController = PageController(initialPage: _currentPage);
        _isLoading = false;
      });
    }
  }

  Future<void> _onPageChanged(int index) async {
    if (index != _currentPage) {
      HapticFeedback.mediumImpact();
      setState(() {
        _currentPage = index;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('daily_feed_index', index);
    }
  }

  Future<void> _handleNextMultiverse(int index) async {
    final completedPost = _posts[index];

    // 1. Mark the current post as completed in the database.
    await PostRepository.markPostUnlocked(completedPost.id);

    // 2. Fetch a fresh unseen post.
    final currentTeasers = _posts.map((p) => p.teaserText).toSet();
    final newPost = PostRepository.fetchUnseenPost(currentTeasers);

    if (newPost != null && mounted) {
      // 3. Replace at the same index and persist the updated feed.
      setState(() {
        _posts[index] = newPost;
      });
      await PostRepository.updateCachedFeed(_posts);
    }
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: AmbientParticles(particleCount: 40),
          ),
          
          if (_isLoading)
            const Center(child: CircularProgressIndicator(color: AppTheme.neonBlue))
          else ...[
            PageView.builder(
              controller: _pageController!,
              scrollDirection: Axis.vertical,
              physics: const PageScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              onPageChanged: _onPageChanged,
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                return PostCard(
                  post: _posts[index],
                  isActive: index == _currentPage,
                  onNextMultiverse: () => _handleNextMultiverse(index),
                );
              },
            ),
            
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicator
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppTheme.neonBlue.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            '${_currentPage + 1}/${_posts.length}',
                            style: const TextStyle(
                              color: AppTheme.neonBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Insight Points badge
                    Consumer<ProgressService>(
                      builder: (context, progress, _) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: AppTheme.neonPurple.withValues(alpha: 0.4)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.auto_awesome, color: AppTheme.neonPurple, size: 16),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${progress.insightPoints} IP',
                                    style: const TextStyle(
                                      color: AppTheme.neonPurple,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
